defmodule Parent do
  use Supervisor

  def start_link(), do: Supervisor.start_link(__MODULE__, [])

  def init(_) do
    [worker(Potato, []), worker(Babysitter, [])]
      |> supervise(strategy: :one_for_one, max_restarts: 2)
  end

  def random(n, offset \\ 0) do
    << a :: 32, b :: 32, c :: 32 >> = :crypto.rand_bytes(12)
    :random.seed(a, b, c)
    offset + :random.uniform(n)
  end
end
