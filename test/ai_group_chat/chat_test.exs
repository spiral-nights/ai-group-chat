defmodule AiGroupChat.ChatTest do
  use AiGroupChat.DataCase

  alias AiGroupChat.Chat

  describe "chat_rooms" do
    alias AiGroupChat.Chat.ChatRoom

    import AiGroupChat.ChatFixtures

    @invalid_attrs %{name: nil}

    test "list_chat_rooms/0 returns all chat_rooms" do
      chat_room = chat_room_fixture()
      assert Chat.list_chat_rooms() == [chat_room]
    end

    test "get_chat_room!/1 returns the chat_room with given id" do
      chat_room = chat_room_fixture()
      assert Chat.get_chat_room!(chat_room.id) == chat_room
    end

    test "create_chat_room/1 with valid data creates a chat_room" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %ChatRoom{} = chat_room} = Chat.create_chat_room(valid_attrs)
      assert chat_room.name == "some name"
    end

    test "create_chat_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chat.create_chat_room(@invalid_attrs)
    end

    test "update_chat_room/2 with valid data updates the chat_room" do
      chat_room = chat_room_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %ChatRoom{} = chat_room} = Chat.update_chat_room(chat_room, update_attrs)
      assert chat_room.name == "some updated name"
    end

    test "update_chat_room/2 with invalid data returns error changeset" do
      chat_room = chat_room_fixture()
      assert {:error, %Ecto.Changeset{}} = Chat.update_chat_room(chat_room, @invalid_attrs)
      assert chat_room == Chat.get_chat_room!(chat_room.id)
    end

    test "delete_chat_room/1 deletes the chat_room" do
      chat_room = chat_room_fixture()
      assert {:ok, %ChatRoom{}} = Chat.delete_chat_room(chat_room)
      assert_raise Ecto.NoResultsError, fn -> Chat.get_chat_room!(chat_room.id) end
    end

    test "change_chat_room/1 returns a chat_room changeset" do
      chat_room = chat_room_fixture()
      assert %Ecto.Changeset{} = Chat.change_chat_room(chat_room)
    end
  end
end
