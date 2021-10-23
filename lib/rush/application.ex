defmodule Rush.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Rush.Repo,
      RushWeb.Telemetry,
      {Phoenix.PubSub, name: Rush.PubSub},
      RushWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Rush.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    RushWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
