defmodule AiGroupChat.Accounts.Invitation do
  use Ecto.Schema
  import Ecto.Changeset

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "invitations" do
    field :email, :string
    field :token, :string

    belongs_to :inviting_user, AiGroupChat.Accounts.User, type: :binary_id
    belongs_to :account, AiGroupChat.Accounts.Account, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(invitation, attrs) do
    invitation
    |> cast(attrs, [:email, :inviting_user_id, :account_id, :token])
    |> validate_required([:email, :inviting_user_id, :account_id, :token])
    |> unique_constraint(:email, name: :invitations_email_account_id_index)
    |> unique_constraint(:token)
  end
end
