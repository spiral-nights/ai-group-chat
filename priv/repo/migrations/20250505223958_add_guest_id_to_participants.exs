defmodule AiGroupChat.Repo.Migrations.AddGuestIdToParticipants do
  use Ecto.Migration

  def change do
    alter table(:participants) do
      add :guest_id, :string
    end
  end
end
