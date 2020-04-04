defmodule EchoServex.Listener do
  use GenServer

  def start_link(socket) do
    GenServer.start_link(__MODULE__, socket)
  end

  @impl true
  def init(socket) do
    send(self(), :listen)
    {:ok, %{socket: socket}}
  end

  @impl true
  def handle_info(:listen, %{socket: socket} = state) do
    {:ok, socket} = :gen_tcp.accept(socket)
    {:ok, receiver_pid} = DynamicSupervisor.start_child(EchoServex.ReceiverSup, {EchoServex.Receiver, socket})
    :gen_tcp.controlling_process(socket, receiver_pid)
    send(self(), :listen)
    {:noreply, state}
  end
end
