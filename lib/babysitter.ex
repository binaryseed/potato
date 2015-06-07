defmodule Babysitter do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = (1..50) |> Enum.map( fn(_n) -> {:ok, pid} = Child.start_link; pid end )

    {:ok, %{children: children}}
  end

  def children(), do: GenServer.call(__MODULE__, :children)
  def grenade(),  do: GenServer.cast(__MODULE__, :grenade)
  def play(),     do: GenServer.call(__MODULE__, :play)
  def boom(pid),  do: GenServer.call(__MODULE__, {:boom, pid})

  def handle_call(:play, _from, %{children: children} = state) do
    state = Map.put(state, :children, Enum.filter(children, &Process.alive?(&1) ))

    IO.puts ""
    Potato.light_fuse
    children |> Enum.each(&Child.hot_potato(&1))

    {:reply, :ok, state}
  end

  def handle_cast(:grenade, %{children: children} = state) do
    IO.puts "grenade"

    # children |> Enum.each( fn(pid) -> Process.unlink(pid); Process.exit(pid, :kill) end )
    Process.exit(self, :grenade)

    {:noreply, state}
  end

  def handle_call({:boom, pid}, _from, state) do
    state = Map.put(state, :children, Enum.filter(children, &Process.alive?(&1) ))

    Process.unlink(pid)
    Process.exit(pid, :kill)

    {:reply, :boom, state}
  end
end
