defmodule AiGroupChatWeb.ChatRoomLive.Show do
  use AiGroupChatWeb, :live_view

  alias AiGroupChat.Chat
  alias AiGroupChat.Chat.Message

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    chat_room = Chat.get_chat_room!(id)
    messages = Chat.list_messages_by_room(chat_room.id)
    topic = "chat_room:#{chat_room.id}"

    changeset = Message.changeset(%Message{}, %{})
    message_form = Phoenix.Component.to_form(changeset)

    if connected?(socket), do: Phoenix.PubSub.subscribe(AiGroupChat.PubSub, topic)
    IO.inspect(messages, label: "\n\n\n\nMessages")
    {:ok, assign(socket, chat_room: chat_room, messages: messages, message_form: message_form)}
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
    # Assuming current_user is assigned to the socket for authenticated users
    user = socket.assigns.current_user

    message_attrs = %{
      content: content,
      chat_room_id: chat_room.id
    }

    message_attrs =
      if user do
        Map.put(message_attrs, :user_id, user.id)
      else
        # For anonymous users, we need a way to get their name.
        # This assumes a "sender_name" field is present in the form or socket assigns.
        # For now, we'll use a placeholder or assume it's in assigns.
        # A more robust solution would involve prompting the user for a name on join.
        Map.put(message_attrs, :sender_name, socket.assigns[:sender_name] || "Anonymous")
      end

    case Chat.create_message(message_attrs) do
      {:ok, message} ->
        topic = "chat_room:#{chat_room.id}"
        Phoenix.PubSub.broadcast(AiGroupChat.PubSub, topic, {:new_message, message})
        {:noreply, assign(socket, :message_content, "")}

      {:error, %Ecto.Changeset{} = changeset} ->
        # Handle errors, e.g., display validation messages
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp page_title(:show), do: "Show Chat room"
  defp page_title(:edit), do: "Edit Chat room"
end
