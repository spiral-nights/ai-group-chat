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
    |> validate_required([:chat_room_id])
    |> validate_required_when(:display_name, :user_id, nil) # Require display_name if user_id is nil
  end

  defp validate_required_when(changeset, field, other_field, value) do
    if get_change(changeset, other_field) == value do
      validate_required(changeset, [field])
    else
      changeset
    end
  end
end
