defmodule AiGroupChat.Repo.Migrations.AddAccountIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :account_id, references(:accounts, type: :binary_id, on_delete: :nothing)
    end

    create index(:users, [:account_id])
  end
end
