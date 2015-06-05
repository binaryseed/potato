defmodule Babysitter do
  use Supervisor
  require IEx

  def start_link() do
    {:ok, pid} = Supervisor.start_link(__MODULE__, [])
    {:ok, play(pid)}
  end

  def init(_) do
    (1..50)
      |> Enum.map( fn(_n) -> worker(Child, [], id: make_ref()) end )
      |> Enum.concat( [worker(Potato, [], id: make_ref())] )
      |> supervise(strategy: :one_for_one, max_restarts: 0)
  end

  def play(pid) do
    IO.puts "PLAY!"
    pid
  end
end
