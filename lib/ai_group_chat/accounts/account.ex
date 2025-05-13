defmodule AiGroupChat.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :name, :string

    belongs_to :owner, AiGroupChat.Accounts.User, type: :binary_id
    has_many :users, AiGroupChat.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :owner_id])
    |> validate_required([:name, :owner_id])
  end
end
