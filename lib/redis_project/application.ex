defmodule RedisProject.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RedisProjectWeb.Telemetry,
      RedisProject.Repo,
      {DNSCluster, query: Application.get_env(:redis_project, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: RedisProject.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: RedisProject.Finch},
      # Start a worker by calling: RedisProject.Worker.start_link(arg)
      # {RedisProject.Worker, arg},
      # Start to serve requests, typically the last entry
      RedisProjectWeb.Endpoint,
      {Redix, name: :redix}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RedisProject.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RedisProjectWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
