defmodule TwitterClone.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      TwitterClone.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: TwitterClone.PubSub}
      # Start a worker by calling: TwitterClone.Worker.start_link(arg)
      # {TwitterClone.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: TwitterClone.Supervisor)
  end
end
