defmodule AiGroupChat.Repo.Migrations.RemoveUserIdFromChatRooms do
  use Ecto.Migration

  def change do
    alter table(:chat_rooms) do
      remove :user_id
    end
  end
end
