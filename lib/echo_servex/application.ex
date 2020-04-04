defmodule EchoServex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      EchoServex.ListenSup,
      EchoServex.ReceiverSup
    ]

    opts = [strategy: :one_for_one, name: EchoServex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
