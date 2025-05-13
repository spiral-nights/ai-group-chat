defmodule AiGroupChat.Chat.ChatRoom do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "chat_rooms" do
    field :name, :string

    belongs_to :account, AiGroupChat.Accounts.Account, type: :binary_id
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chat_room, attrs) do
    chat_room
    |> cast(attrs, [:name, :account_id])
    |> validate_required([:name, :account_id])
    |> unique_constraint(:name) # Consider if name should be unique per account
  end
end
