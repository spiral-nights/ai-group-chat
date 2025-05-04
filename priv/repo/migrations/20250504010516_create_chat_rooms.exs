defmodule AiGroupChat.Repo.Migrations.CreateChatRooms do
  use Ecto.Migration

  def change do
    create table(:chat_rooms, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :user_id, references(:users, type: :uuid, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:chat_rooms, [:name])
    create index(:chat_rooms, [:user_id])
  end
end
