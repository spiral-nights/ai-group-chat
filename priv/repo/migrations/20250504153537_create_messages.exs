defmodule AiGroupChat.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do # Use default primary key (bigint)
      add :content, :string, null: false
      add :participant_id, references(:participants, type: :binary_id, on_delete: :nothing), null: false
      add :chat_room_id, references(:chat_rooms, type: :binary_id, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:messages, [:participant_id])
    create index(:messages, [:chat_room_id])
  end
end
