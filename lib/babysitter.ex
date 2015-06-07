defmodule Babysitter do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = (1..50) |> Enum.map( fn(_n) -> {:ok, pid} = Child.start_link; pid end )
    Babysitter.play
    {:ok, %{children: children}}
  end

  def grenade(),  do: GenServer.cast(__MODULE__, :grenade)
  def play(),     do: GenServer.cast(__MODULE__, :play)
  def boom(pid),  do: GenServer.cast(__MODULE__, {:boom, pid})

  # Server
  def handle_cast(:play, %{children: [winner | []]} = state) do
    IO.puts "\n!"
    Process.exit(self, :kill)

    {:noreply, state}
  end

  def handle_cast(:play, %{children: children} = state) do
    IO.puts ""

    Potato.light_fuse
    Child.hot_potato(children)

    {:noreply, state}
  end

  def handle_cast(:grenade, %{children: children} = state) do
    Process.exit(self, :kill)

    {:noreply, state}
  end

  def handle_cast({:boom, pid}, %{children: children} = state) do
    Process.unlink(pid)
    Process.exit(pid, :kill)

    state = Map.put(state, :children, Enum.filter(children, &Process.alive?(&1) ))

    {:noreply, state}
  end
end
