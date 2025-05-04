defmodule AiGroupChatWeb.ChatRoomLive.Show do
  use AiGroupChatWeb, :live_view

  alias AiGroupChat.Chat

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:chat_room, Chat.get_chat_room!(id))}
  end

  defp page_title(:show), do: "Show Chat room"
  defp page_title(:edit), do: "Edit Chat room"
end
