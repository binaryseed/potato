defmodule Potato do
  use GenServer

  def start_link(), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def init(_),      do: {:ok, {:potato, :holder}}

  def check(),      do: GenServer.call(__MODULE__, :check)
  def poison(),     do: GenServer.call(__MODULE__, :poison)
  def light_fuse(), do: GenServer.cast(__MODULE__, :light_fuse)

  # Server
  def handle_call(:check, {child, _ref}, {status, _holder}),   do: {:reply, status, {:potato, child}}
  def handle_call(:poison, {_child, _ref}, {_status, holder}), do: {:reply, :ok, {:grenade, holder}}

  def handle_cast(:light_fuse, {status, holder}) do
    Process.send_after(self, :boom, 2)

    {:noreply, {status, holder}}
  end

  def handle_info(:boom, {status, holder}) do
    Babysitter.boom(holder)

    {:noreply, {status, holder}}
  end
end
