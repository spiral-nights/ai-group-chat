defmodule AiGroupChat.Repo.Migrations.CreateChatRooms do
  use Ecto.Migration

  def change do
    create table(:chat_rooms) do
      add :name, :string
      add :user_id, references(:users, type: :uuid, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:chat_rooms, [:name])
    create index(:chat_rooms, [:user_id])
  end
end
