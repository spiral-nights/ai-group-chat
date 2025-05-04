defmodule AiGroupChat.ChatFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AiGroupChat.Chat` context.
  """

  @doc """
  Generate a unique chat_room name.
  """
  def unique_chat_room_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a chat_room.
  """
  def chat_room_fixture(attrs \\ %{}) do
    {:ok, chat_room} =
      attrs
      |> Enum.into(%{
        name: unique_chat_room_name()
      })
      |> AiGroupChat.Chat.create_chat_room()

    chat_room
  end
end
