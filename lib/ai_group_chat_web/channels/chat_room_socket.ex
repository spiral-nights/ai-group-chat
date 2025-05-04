defmodule AiGroupChatWeb.ChatRoomSocket do
  use Phoenix.Socket

  ## Channels
  channel "chat_room:*", AiGroupChatWeb.ChatRoomChannel

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be available for all channels,
  # such as the current user ID. Or you can verify the
  # user token and assign it to the socket.
  @impl true
  def connect(_params, socket, _connect_info) do
    # Example authentication:
    # case Phoenix.Token.verify(socket, "user socket", params["token"], max_age: 1_209_600) do
    #   {:ok, user_id} ->
    #     {:ok, assign(socket, :user_id, user_id)}
    #   {:error, reason} ->
    #     :error
    # end
    {:ok, socket}
  end

  # Socket id's are topics that allow you to identify all sockets for a given user
  # uniquely through PubSub and Phoenix Channels. The id should be signed.
  # @impl true
  # def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  @impl true
  def id(_socket), do: nil
end
