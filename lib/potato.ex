defmodule Potato do
  use GenServer

  def start_link(), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def init(_),      do: {:ok, {:potato, :holder}}

  def check(),      do: GenServer.call(__MODULE__, :check)
  def poison(),     do: GenServer.call(__MODULE__, :poison)
  def light_fuse(), do: GenServer.cast(__MODULE__, :light_fuse)

  # Server
  def handle_call(:check, from, {state, _holder}) do
    {:reply, state, {:potato, from}}
  end

  def handle_call(:poison, _from, {_status, holder}) do
    {:reply, :ok, {:grenade, holder}}
  end

  def handle_cast(:light_fuse, state) do
    :timer.send_after(2, self, :boom)
    {:noreply, state}
  end

  def handle_info(:boom, {status, {pid, _ref} = holder}) do
    Babysitter.boom(pid)

    {:noreply, {status, holder}}
  end
end
