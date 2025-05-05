defmodule AiGroupChatWeb.ChatRoomLive.Show do
  use AiGroupChatWeb, :live_view

  alias AiGroupChat.Chat
  alias AiGroupChat.Chat.Message
  alias Plug.Conn
  alias Ecto.UUID

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    chat_room = Chat.get_chat_room!(id)
    messages = Chat.list_messages_by_room(chat_room.id)
    topic = "chat_room:#{chat_room.id}"

    if connected?(socket), do: Phoenix.PubSub.subscribe(AiGroupChat.PubSub, topic)

    # Add the structure for the new message
    message_form = empty_message_form()

    {:ok,
     assign(socket,
       chat_room: chat_room,
       messages: messages,
       message_form: message_form,
       participant: nil # Participant is nil initially
     )}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:chat_room, Chat.get_chat_room!(id))}
  end

  @impl true
  def handle_info({:new_message, message}, socket) do
    {:noreply, update(socket, :messages, fn messages -> messages ++ [message] end)}
  end

  @impl true
  def handle_event("guest-id-event", %{"guest_id" => guest_id}, socket) do
    chat_room = socket.assigns.chat_room
    user = get_in(socket.assigns, [:current_user])

    {participant, socket} =
      if user do
        # Find or create participant for registered user
        case Chat.find_or_create_participant_for_user(chat_room.id, user.id) do
          {:ok, participant} ->
            {participant, socket}

          # Handle error appropriately
          {:error, _} ->
            {nil, socket}
        end
      else
        # Handle anonymous user with guest_id from local storage
        case guest_id do
          nil ->
            # No guest_id in local storage, create a new participant and generate a new guest_id
            new_guest_id = create_guest_id()

            attrs = %{
              chat_room_id: chat_room.id,
              guest_id: new_guest_id,
              display_name: "Guest-#{String.upcase(String.slice(new_guest_id, 0, 4))}"
            }

            case Chat.create_participant(attrs) do
              {:ok, participant} ->
                # Push event to client to store the new guest_id in local storage
                {participant, push_event(socket, "store-guest-id", %{id: new_guest_id})}

              {:error, error} ->
                IO.inspect(error, label: "error creating anonymous participant")
                {nil, socket}
            end

          guest_id ->
            # guest_id exists in local storage, try to find the participant
            case Chat.find_participant_by_guest_id(chat_room.id, guest_id) do
              nil ->
                # Participant not found with this guest_id, create a new one and update local storage
                new_guest_id = create_guest_id()

                attrs = %{
                  chat_room_id: chat_room.id,
                  guest_id: new_guest_id,
                  display_name: "Guest-#{String.upcase(String.slice(new_guest_id, 0, 4))}"
                }

                case Chat.create_participant(attrs) do
                  {:ok, participant} ->
                    # Push event to client to store the new guest_id in local storage
                    {participant, push_event(socket, "store-guest-id", %{id: new_guest_id})}

                  {:error, error} ->
                    IO.inspect(error,
                      label: "error creating anonymous participant with existing guest_id"
                    )

                    {nil, socket}
                end

              participant ->
                # Participant found, return it
                {participant, socket}
            end
        end
      end

    {:noreply, assign(socket, :participant, participant)}
  end

  @impl true
  def handle_event("send_message", %{"message" => %{"content" => content}}, socket) do
    chat_room = socket.assigns.chat_room
    # Assuming participant is assigned to the socket
    participant = socket.assigns.participant

    IO.inspect(participant, label: "participant")

    message_attrs = %{
      content: content,
      chat_room_id: chat_room.id,
      participant_id: participant.id
    }

    case Chat.create_message(message_attrs) do
      {:ok, message} ->
        topic = "chat_room:#{chat_room.id}"
        # Preload participant and user before broadcasting
        message = AiGroupChat.Repo.preload(message, participant: [:user])
        Phoenix.PubSub.broadcast(AiGroupChat.PubSub, topic, {:new_message, message})
        {:noreply, assign(socket, message_form: empty_message_form())}

      {:error, %Ecto.Changeset{} = changeset} ->
        # Handle errors, e.g., display validation messages
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp page_title(:show), do: "Show Chat room"
  defp page_title(:edit), do: "Edit Chat room"

  defp empty_message_form(), do: to_form(Message.changeset(%Message{}, %{}))

  defp create_guest_id() do
    token = :crypto.strong_rand_bytes(32)
    hashed_token = :crypto.hash(:sha256, token)
    Base.url_encode64(hashed_token, padding: false)
  end
end
