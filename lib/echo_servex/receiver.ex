defmodule EchoServex.Receiver do
  use GenServer, restart: :temporary
  require Logger

  def start_link(socket) do
    GenServer.start_link(__MODULE__, socket)
  end

  @impl true
  def init(socket) do
    :inet.setopts(socket, [{:active, :once}])
    {:ok, %{socket: socket, chunks: []}}
  end

  @impl true
  def handle_info({:tcp, socket, data}, %{socket: socket, chunks: chunks} = state) do
    case String.last(data) do
      "\n" ->
        complete_data = List.foldr(chunks, "", &(&2 <> &1)) <> data
        Logger.info(complete_data)
        :gen_tcp.send(socket, complete_data)
        {:noreply, state}
      _ ->
        :inet.setopts(socket, [{:active, :once}])
        {:noreply, %{state | chunks: [data | chunks]}}
    end
  end
  def handle_info({:tcp_closed, socket}, %{socket: socket} = state) do
    {:stop, :tcp_closed, state}
  end
end
