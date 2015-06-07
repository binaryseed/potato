defmodule Parent do
  use Supervisor

  def start_link(), do: Supervisor.start_link(__MODULE__, [])

  def init(_) do
    [worker(Potato, []), worker(Babysitter, [])]
      |> supervise(strategy: :one_for_one, max_restarts: 2)
  end
end
