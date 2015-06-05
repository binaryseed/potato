defmodule Potato do
  use GenServer

  # API
  def start_link(), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)
  def reset(),      do: GenServer.call(__MODULE__, :reset)
  def check(),      do: GenServer.call(__MODULE__, :check)
  def poison(),     do: GenServer.call(__MODULE__, :poison)
  def light_fuse(), do: GenServer.call(__MODULE__, :light_fuse)

  # Server
  def init(_) do
    {:ok, {:potato, :holder, :sitter}}
  end

  def handle_call(:reset, from, {status, _holder, sitter}) do
    {:reply, :potato, {:potato, :holder, sitter}}
  end

  def handle_call(:check, from, {status, _holder, sitter}) do
    {:reply, status, {status, from, sitter}}
  end

  def handle_call(:poison, _from, {_status, holder, sitter}) do
    {:reply, :grenade, {:grenade, holder, sitter}}
  end

  def handle_call(:light_fuse, _from, state) do
    :timer.send_after(Parent.random(500, 500), self, :blow)
    {:reply, :lit, state}
  end

  def handle_info(:blow, {status, {pid, ref}, sitter}) do
    IO.write "\\"
    Process.exit(pid, :kill)
    {:noreply, {status, :holder, sitter}}
  end
end
