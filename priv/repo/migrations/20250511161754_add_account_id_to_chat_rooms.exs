defmodule AiGroupChat.Repo.Migrations.AddAccountIdToChatRooms do
  use Ecto.Migration

  def change do
    alter table(:chat_rooms) do
      add :account_id, references(:accounts, on_delete: :nothing, type: :uuid)
    end
  end
end
