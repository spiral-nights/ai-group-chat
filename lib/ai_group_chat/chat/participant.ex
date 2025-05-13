defmodule AiGroupChat.Chat.Participant do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "participants" do
    belongs_to :chat_room, AiGroupChat.Chat.ChatRoom, type: :binary_id
    belongs_to :user, AiGroupChat.Accounts.User, foreign_key: :user_id, type: :binary_id
    field :display_name, :string

    has_many :messages, AiGroupChat.Chat.Message

    timestamps()
  end

  @doc false
  def changeset(participant, attrs) do
    participant
    |> cast(attrs, [:chat_room_id, :user_id, :display_name])
    |> validate_required([:chat_room_id, :user_id])
  end
end
