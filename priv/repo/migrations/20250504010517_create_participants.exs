defmodule AiGroupChat.Repo.Migrations.CreateParticipants do
  use Ecto.Migration

  def change do
    create table(:participants, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :chat_room_id, references(:chat_rooms, type: :binary_id, on_delete: :nothing), null: false
      add :user_id, references(:users, type: :binary_id, on_delete: :nothing), null: true
      add :display_name, :string

      timestamps()
    end

    create index(:participants, [:chat_room_id])
    create index(:participants, [:user_id])
  end
end
