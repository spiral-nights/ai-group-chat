defmodule AiGroupChatWeb.ChatRoomChannel do
  use Phoenix.Channel

  def join("chat_room:" <> chat_room_id, payload, socket) do
    # You can authenticate the user here if needed
    # For now, we'll allow anyone to join if they have the room ID
    {:ok, socket}
  end

  # Channels can also be used in a request/response fashion
  # For example, a client may send a message to the server:
  # push socket, "new_message", %{body: "Hello"}

  # Messages can be broadcast to all subscribers:
  # broadcast! socket, "new_message", %{body: "Hello"}
end
