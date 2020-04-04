defmodule EchoServex.Listener do
  use GenServer
  require Logger

  # API

  def start_link(socket) do
    GenServer.start_link(__MODULE__, socket)
  end

  # Callbacks

  @impl true
  def init(socket) do
    send(self(), :listen)
    {:ok, %{socket: socket}}
  end

  @impl true
  def handle_info(:listen, %{socket: socket} = state) do
    with {:ok, socket} <- :gen_tcp.accept(socket),
         {:ok, receiver_pid} <- start_receiver(socket)
    do
      :gen_tcp.controlling_process(socket, receiver_pid)
      send(self(), :listen)
    else
      err -> Logger.error(err)
    end
    {:noreply, state}
  end

  # Helpers

  defp start_receiver(socket) do
    DynamicSupervisor.start_child(EchoServex.ReceiverSup,
      {EchoServex.Receiver, socket})
  end
end
