defmodule Potato do
  use GenServer

  # API
  def start(),     do: GenServer.start_link(__MODULE__, [])
  def check(pid),  do: GenServer.call(pid, :check)
  def poison(pid), do: GenServer.call(pid, :poison)

  # Server
  def init(_) do
    {:ok, {:potato, :holder}}
  end

  def handle_call(:check, from, {status, holder}) do
    {:reply, status, {status, from}}
  end

  def handle_call(:poison, from, {status, holder}) do
    {:reply, :grenade, {:grenade, holder}}
  end
end
