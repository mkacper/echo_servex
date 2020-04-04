defmodule EchoServex.ReceiverSup do
  use DynamicSupervisor

  # API

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  # Callbacks

  @impl true
  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
