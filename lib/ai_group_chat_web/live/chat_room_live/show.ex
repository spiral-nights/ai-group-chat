defmodule AiGroupChatWeb.ChatRoomLive.Show do
  use AiGroupChatWeb, :live_view

  alias AiGroupChat.Chat
  alias AiGroupChat.Chat.Message

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    chat_room = Chat.get_chat_room!(id)
    messages = Chat.list_messages_by_room(chat_room.id)
    topic = "chat_room:#{chat_room.id}"

    # Handle participant creation/lookup
    user = get_in(socket.assigns, [:current_user]) || nil

    participant =
      if connected?(socket) do
        if user do
          # Find or create participant for registered user
          case Chat.find_or_create_participant_for_user(chat_room.id, user.id) do
            {:ok, participant} ->
              participant

            # Handle error appropriately
            {:error, _} ->
              nil
          end
        else
          # Find or create participant for anonymous user (based on session or other identifier)
          # This is a placeholder and needs a proper implementation for anonymous user identification
          # Using socket.id as a temporary identifier
          IO.puts("in anon block")
          case Chat.find_or_create_participant_for_anonymous(chat_room.id) do
            {:ok, participant} -> participant
            # Handle error appropriately
            {:error, error} ->
              IO.inspect(error, label: "error is")
              nil
          end
        end
      else
        # No participant for now -- wait until socket connection
        nil
      end

    IO.inspect(participant, label: "participant is")

    if connected?(socket), do: Phoenix.PubSub.subscribe(AiGroupChat.PubSub, topic)

    # Add the structure for the new message
    changeset = Message.changeset(%Message{}, %{})
    message_form = empty_message_form()

    {:ok,
     assign(socket,
       chat_room: chat_room,
       messages: messages,
       message_form: message_form,
       participant: participant
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
end
