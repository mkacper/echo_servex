defmodule EchoServex.ListenSup do
  use Supervisor
  require Logger
  @listener_count 10

  # API

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  # Callbacks

  @impl true
  def init([]) do
    listen_port = listen_port()
    Logger.info("Listening port: #{listen_port}")
    {:ok, listen_socket} = :gen_tcp.listen(listen_port, [:binary, {:active, :false}])
    children =
      for id <- 1..@listener_count,
        do: Supervisor.child_spec({EchoServex.Listener, listen_socket}, id: id)

    Supervisor.init(children, strategy: :one_for_one)
  end

  # Helpers

  defp listen_port() do
    :rand.uniform(1000) + 1000
  end
end
