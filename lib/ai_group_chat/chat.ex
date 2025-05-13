defmodule AiGroupChat.Chat do
  @moduledoc """
  The Chat context.
  """

  import Ecto.Query, warn: false
  alias AiGroupChat.Repo

  alias AiGroupChat.Chat.ChatRoom
  alias AiGroupChat.Chat.Message

  @doc """
  Returns the list of chat_rooms.

  ## Examples

      iex> list_chat_rooms()
      [%ChatRoom{}, ...]

  """
  def list_chat_rooms do
    Repo.all(ChatRoom)
  end

  @doc """
  Returns the list of chat_rooms for the given account.

  ## Examples

      iex> list_chat_rooms_for_account(123)
      [%ChatRoom{}, ...]

  """
  def list_chat_rooms_for_account(account_id) do
    case Repo.get_by(ChatRoom, account_id: account_id) do
      room_list when is_list(room_list) -> room_list
      nil -> []
      single_item -> [single_item]
    end
  end

  @doc """
  Gets a single chat_room.

  Raises `Ecto.NoResultsError` if the Chat room does not exist.

  ## Examples

      iex> get_chat_room!(123)
      %ChatRoom{}

      iex> get_chat_room!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chat_room!(id), do: Repo.get!(ChatRoom, id)

  @doc """
  Creates a chat_room.

  ## Examples

      iex> create_chat_room(%{field: value})
      {:ok, %ChatRoom{}}

      iex> create_chat_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chat_room(attrs \\ %{}, %AiGroupChat.Accounts.User{} = creator) do
    %ChatRoom{id: Ecto.UUID.generate()}
    |> ChatRoom.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, chat_room} ->
        # Create a participant for the creator
        case create_participant(%{
               chat_room_id: chat_room.id,
               user_id: creator.id,
               # Using email as display name for now
               display_name: creator.email
             }) do
          {:ok, _participant} ->
            {:ok, chat_room}

          {:error, reason} ->
            # Handle error creating participant, maybe delete the chat room
            Repo.delete(chat_room)
            {:error, reason}
        end

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Updates a chat_room.

  ## Examples

      iex> update_chat_room(chat_room, %{field: new_value})
      {:ok, %ChatRoom{}}

      iex> update_chat_room(chat_room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chat_room(%ChatRoom{} = chat_room, attrs) do
    chat_room
    |> ChatRoom.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a chat_room.

  ## Examples

      iex> delete_chat_room(chat_room)
      {:ok, %ChatRoom{}}

      iex> delete_chat_room(chat_room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chat_room(%ChatRoom{} = chat_room) do
    Repo.delete(chat_room)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking chat_room changes.

  ## Examples

      iex> change_chat_room(chat_room)
      %Ecto.Changeset{data: %ChatRoom{}}

  """
  def change_chat_room(%ChatRoom{} = chat_room, attrs \\ %{}) do
    ChatRoom.changeset(chat_room, attrs)
  end

  alias AiGroupChat.Chat.Participant

  @doc """
  Returns the list of participants for a chat room.
  """
  def list_participants_by_room(chat_room_id) do
    Repo.all(
      from p in Participant,
        where: p.chat_room_id == ^chat_room_id
    )
  end

  @doc """
  Gets a single participant.

  Raises `Ecto.NoResultsError` if the Participant does not exist.
  """
  def get_participant!(id), do: Repo.get!(Participant, id)

  @doc """
  Creates a participant.

  ## Examples

      iex> create_participant(%{ chat_room_id: chat_room.id, user_id: user.id })
      {:ok, %Participant{}}

      iex> create_participant(%{ chat_room_id: chat_room.id, display_name: "Guest" })
      {:ok, %Participant{}}

      iex> create_participant(%{ chat_room_id: chat_room.id })
      {:error, %Ecto.Changeset{}}
  """
  def create_participant(attrs \\ %{}) do
    %Participant{}
    |> Participant.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{ content: "Hello", chat_room_id: chat_room.id, participant_id: participant.id })
      {:ok, %Message{}}

      iex> create_message(%{ content: "Bad message" })
      {:error, %Ecto.Changeset{}}
  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns the list of messages for a chat room, preloading participants and their users.
  """
  def list_messages_by_room(chat_room_id) do
    Repo.all(
      from m in Message,
        join: p in assoc(m, :participant),
        left_join: u in assoc(p, :user),
        where: m.chat_room_id == ^chat_room_id,
        order_by: m.inserted_at,
        preload: [participant: [:user]]
    )
  end

  @doc """
  Finds a participant by guest ID and chat room ID.
  """
  def find_participant_by_guest_id(chat_room_id, guest_id) do
    Repo.get_by(Participant, chat_room_id: chat_room_id, guest_id: guest_id)
  end

  @doc """
  Finds or creates a participant for a registered user in a chat room.
  """
  def find_or_create_participant_for_user(chat_room_id, user_id) do
    # Placeholder implementation:
    # In a real application, you would query for an existing participant
    # with the given chat_room_id and user_id. If found, return it.
    # If not found, create a new participant with chat_room_id and user_id.
    # For now, we'll just create a new one every time (this is NOT correct for production).
    # TODO: Fix display name to not make it based on user id
    # create_participant(%{
    #   chat_room_id: chat_room_id,
    #   user_id: user_id,
    #   display_name: String.slice(user_id, 0, 4)
    # })

    case Repo.get_by(Participant, chat_room_id: chat_room_id, user_id: user_id) do
      nil ->
        create_participant(%{
          chat_room_id: chat_room_id,
          user_id: user_id,
          display_name: generate_display_name()
        })

      participant ->
        {:ok, participant}
    end
  end

  @doc """
  Finds or creates a participant for an anonymous user in a chat room.
  """
  def find_or_create_participant_for_anonymous(chat_room_id) do
    # Placeholder implementation:
    # In a real application, you would need a way to uniquely identify an anonymous user's session
    # across LiveView mounts to find an existing participant. This is a simplified approach.
    # We'll generate a random identifier for the display name for now.
    # TODO: Implement real version via cookies
    create_participant(%{
      chat_room_id: chat_room_id,
      display_name: "Guest-#{String.upcase(generate_display_name())}"
    })
  end

  defp generate_display_name() do
    :rand.uniform(36 ** 4) |> Integer.to_string(36) |> String.pad_leading(4, "0")
  end

  @doc """
  Gets a participant by chat room ID and user ID.

  ## Examples

      iex> get_participant_by_room_and_user(chat_room.id, user.id)
      %Participant{}

      iex> get_participant_by_room_and_user(chat_room.id, "invalid_user_id")
      nil

  """
  def get_participant_by_room_and_user(chat_room_id, user_id) do
    Repo.get_by(Participant, chat_room_id: chat_room_id, user_id: user_id)
  end

  @doc """
  Adds a user as a participant to a chat room.

  Verifies that both the user adding and the user being added are in the same account.

  ## Examples

      iex> add_user_to_chat_room(chat_room, adding_user, user_to_add)
      {:ok, %Participant{}}

      iex> add_user_to_chat_room(chat_room, adding_user, user_in_different_account)
      {:error, :users_not_in_same_account}

      iex> add_user_to_chat_room(chat_room, adding_user, user_already_in_room)
      {:error, :user_already_in_room}

  """
  def add_user_to_chat_room(
        %ChatRoom{} = chat_room,
        %AiGroupChat.Accounts.User{} = adding_user,
        %AiGroupChat.Accounts.User{} = user_to_add
      ) do
    # Verify both users are in the same account
    if adding_user.account_id != user_to_add.account_id do
      {:error, :users_not_in_same_account}
    else
      # Check if the user is already a participant
      if get_participant_by_room_and_user(chat_room.id, user_to_add.id) do
        {:error, :user_already_in_room}
      else
        # Create participant for the user being added
        create_participant(%{
          chat_room_id: chat_room.id,
          user_id: user_to_add.id,
          # Using email as display name for now
          display_name: user_to_add.email
        })
      end
    end
  end
end
