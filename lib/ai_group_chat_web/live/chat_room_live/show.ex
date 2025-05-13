defmodule AiGroupChatWeb.ChatRoomLive.Show do
  use AiGroupChatWeb, :live_view

  alias AiGroupChat.Chat
  alias AiGroupChat.Chat.Message
  alias AiGroupChat.Accounts

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    chat_room = Chat.get_chat_room!(id)
    messages = Chat.list_messages_by_room(chat_room.id)
    topic = "chat_room:#{chat_room.id}"

    if connected?(socket), do: Phoenix.PubSub.subscribe(AiGroupChat.PubSub, topic)

    # Add the structure for the new message form
    message_form = empty_message_form()
    user = socket.assigns.current_user

    # Check if the user is a participant in the chat room
    participant = Chat.get_participant_by_room_and_user(chat_room.id, user.id)

    if participant do
      # Fetch users in the same account, excluding current user and existing participants
      existing_participant_user_ids =
        Chat.list_participants_by_room(chat_room.id)
        |> Enum.map(& &1.user_id)

      users_to_add =
        if user.account_id do
          Accounts.list_users_by_account_excluding(user.account_id, [user.id | existing_participant_user_ids])
        else
          [] # User is not in an account, no users to add
        end

      {:ok,
       assign(socket,
         chat_room: chat_room,
         messages: messages,
         message_form: message_form,
         participant: participant,
         users_to_add: users_to_add,
         selected_user_id: nil
       )}
    else
      # User is not a participant, redirect or show unauthorized message
      {:ok,
       socket
       |> put_flash(:error, "You do not have access to this chat room.")
       |> redirect(to: ~p"/")} # Redirect to home or a specific unauthorized page
    end
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

  @impl true
  def handle_event("select_user_to_add", %{"user_id" => user_id}, socket) do
    {:noreply, assign(socket, selected_user_id: user_id)}
  end

  @impl true
  def handle_event("add_participant", %{"user_id" => user_id}, socket) do
    chat_room = socket.assigns.chat_room
    adding_user = socket.assigns.current_user

    # Retrieve the user to be added
    user_to_add = Accounts.get_user!(user_id)

    case Chat.add_user_to_chat_room(chat_room, adding_user, user_to_add) do
      {:ok, _participant} ->
        # Successfully added, update users_to_add and clear selected user
        updated_users_to_add = Enum.reject(socket.assigns.users_to_add, &(&1.id == user_id))

        {:noreply,
         socket
         |> assign(users_to_add: updated_users_to_add, selected_user_id: nil)
         |> put_flash(:info, "#{user_to_add.email} has been added to the chat room.")}

      {:error, :users_not_in_same_account} ->
        {:noreply, socket |> put_flash(:error, "User is not in the same account.")}

      {:error, :user_already_in_room} ->
        {:noreply, socket |> put_flash(:error, "User is already in the chat room.")}

      {:error, _reason} ->
        {:noreply, socket |> put_flash(:error, "Could not add user to chat room.")}
    end
  end

  defp page_title(:show), do: "Show Chat room"
  defp page_title(:edit), do: "Edit Chat room"

  defp empty_message_form(), do: to_form(Message.changeset(%Message{}, %{}))
end
