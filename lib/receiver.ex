defmodule EchoServex.Receiver do
  use GenServer, restart: :temporary

  def start_link(socket) do
    GenServer.start_link(__MODULE__, socket)
  end

  @impl true
  def init(socket) do
    :inet.setopts(socket, [{:active, :once}])
    {:ok, %{socket: socket}}
  end

  @impl true
  def handle_info({:tcp, socket, data}, %{socket: socket} = state) do
    IO.inspect data
    :gen_tcp.send(socket, data)
    :inet.setopts(socket, [{:active, :once}])
    {:noreply, state}
  end
  def handle_info({:tcp_closed, socket}, %{socket: socket} = state) do
    {:stop, :tcp_closed, state}
  end
end
