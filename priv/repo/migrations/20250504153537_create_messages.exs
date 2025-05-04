defmodule AiGroupChat.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :content, :string, null: false
      add :sender_name, :string
      add :user_id, references(:users, type: :uuid, on_delete: :nothing)
      add :chat_room_id, references(:chat_rooms, type: :uuid, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:messages, [:chat_room_id])
    create index(:messages, [:user_id])
  end
end
