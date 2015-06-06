defmodule Babysitter do
  use Supervisor

  def start_link() do
    {:ok, pid} = Supervisor.start_link(__MODULE__, [])

    Potato.reset
    play(pid)

    {:ok, pid}
  end

  def init(_) do
    (1..50)
      |> Enum.map( fn(_n) -> worker(Child, [self], id: make_ref()) end )
      |> supervise(strategy: :one_for_one, max_restarts: 0)
  end

  def sleep(sitter) do

  end

  def play(sitter) do
    IO.puts ""

    Potato.light_fuse

    [child | kids] = Supervisor.which_children(sitter)
                     |> Enum.map( fn({_, pid, _, [Child]}) -> pid end )

    Child.hot_potato(child, kids)
  end
end
