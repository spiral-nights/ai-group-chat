defmodule AiGroupChat.Repo do
  use Ecto.Repo,
    otp_app: :ai_group_chat,
    adapter: Ecto.Adapters.Postgres
end
