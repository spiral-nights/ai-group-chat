defmodule AiGroupChat.Repo.Migrations.CreateInvitations do
  use Ecto.Migration

  def change do
    create table(:invitations) do
      add :email, :string
      add :inviting_user_id, references(:users, type: :binary_id, on_delete: :nothing)
      add :account_id, references(:accounts, type: :binary_id, on_delete: :nothing)
      add :token, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:invitations, [:inviting_user_id])
    create index(:invitations, [:account_id])
    create unique_index(:invitations, [:email, :account_id])
    create unique_index(:invitations, [:token])
  end
end
