defmodule Child do
  use GenServer

  def start_link(), do: GenServer.start_link(__MODULE__, {sociopath?(25)})

  def init({true}),  do: {:ok, :sociopath}
  def init({false}), do: {:ok, :normie}

  def hot_potato(pid) do
    :timer.sleep(Parent.random(2))
    GenServer.call(pid, :hot_potato)
  end

  # Server
  def handle_call(:hot_potato, _from, :normie) do
    case Potato.check do
      :potato  ->
        IO.write "."
      :grenade ->
        IO.write "x"
        Babysitter.grenade
    end

    {:reply, :ok, :normie}
  end

  def handle_call(:hot_potato, _from, :sociopath) do
    case Potato.check do
      :potato  ->
        IO.write ">"
        Potato.poison
      :grenade ->
        IO.write "X"
        Babysitter.grenade
    end

    {:reply, :ok, :sociopath}
  end

# end?

  def sociopath?(n), do: Parent.random(n) == 13
end
