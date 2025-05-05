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
  def create_chat_room(attrs \\ %{}) do
    %ChatRoom{id: Ecto.UUID.generate()}
    |> ChatRoom.changeset(attrs)
    |> Repo.insert()
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
      participant -> {:ok, participant}
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
end
