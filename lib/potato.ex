defmodule Potato do
  use GenServer

  def start_link(), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)
  def reset(),      do: GenServer.call(__MODULE__, :reset)
  def check(),      do: GenServer.call(__MODULE__, :check)
  def poison(),     do: GenServer.call(__MODULE__, :poison)
  def light_fuse(), do: GenServer.call(__MODULE__, :light_fuse)

  # Server
  def init(_) do
    {:ok, {:potato, :holder}}
  end

  def handle_call(:reset, _from, {_status, _holder}) do
    {:reply, :potato, {:potato, :holder}}
  end

  def handle_call(:check, from, {:potato, _holder}) do
    {:reply, :potato, {:potato, from}}
  end

  def handle_call(:check, from, {:grenade, _holder}) do
    {:reply, :grenade, {:potato, from}}
  end

  def handle_call(:poison, _from, {_status, holder}) do
    {:reply, :grenade, {:grenade, holder}}
  end

  def handle_call(:light_fuse, _from, state) do
    # :timer.send_after(Parent.random(50, 10), self, :blow)
    {:reply, :lit, state}
  end

  def handle_info(:blow, {status, {pid, _ref} = holder}) do
    Babysitter.boom(pid)

    {:noreply, {status, holder}}
  end
end
