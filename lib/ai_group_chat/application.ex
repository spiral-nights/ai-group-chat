defmodule AiGroupChat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AiGroupChatWeb.Telemetry,
      AiGroupChat.Repo,
      {DNSCluster, query: Application.get_env(:ai_group_chat, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AiGroupChat.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: AiGroupChat.Finch},
      # Start a worker by calling: AiGroupChat.Worker.start_link(arg)
      # {AiGroupChat.Worker, arg},
      # Start to serve requests, typically the last entry
      AiGroupChatWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AiGroupChat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AiGroupChatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
