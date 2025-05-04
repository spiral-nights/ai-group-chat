defmodule AiGroupChat.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :content, :string
    belongs_to :participant, AiGroupChat.Chat.Participant, type: :binary_id
    belongs_to :chat_room, AiGroupChat.Chat.ChatRoom, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :participant_id, :chat_room_id])
    |> validate_required([:content, :participant_id, :chat_room_id])
  end
end
