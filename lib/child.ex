defmodule Child do
  use GenServer

  def start_link(), do: GenServer.start_link(__MODULE__, {sociopath?(50)})

  def init({true}),  do: {:ok, :sociopath}
  def init({false}), do: {:ok, :normie}

  def hot_potato([]) do
    Babysitter.play
  end

  def hot_potato([child | kids]) do
    :timer.sleep(Parent.random(2))
    GenServer.call(child, {:hot_potato, kids})
  end

  # Server
  def handle_call({:hot_potato, children}, _from, :normie) do
    case Potato.check do
      :potato  ->
        IO.write "."
        Child.hot_potato(children)
      :grenade ->
        IO.write "x"
        Babysitter.grenade
    end

    {:reply, :ok, :normie}
  end

  def handle_call({:hot_potato, children}, _from, :sociopath) do
    case Potato.check do
      :potato  ->
        IO.write ">"
        Potato.poison
        Child.hot_potato(children)
      :grenade ->
        IO.write "X"
        Babysitter.grenade
    end

    {:reply, :ok, :sociopath}
  end

  def sociopath?(n), do: Parent.random(n) == 13
end
