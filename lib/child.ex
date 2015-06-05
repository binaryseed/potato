defmodule Child do
  use GenServer

  def start_link(), do: GenServer.start_link(__MODULE__, sociopath?(25))
  def hot_potato(child, kids, sitter) do
    :timer.sleep(Parent.random(5, 5))
    GenServer.cast(child, {:hot_potato, kids, sitter})
  end

  def init(true),  do: {:ok, :sociopath}
  def init(false), do: {:ok, :normie}

  def handle_cast({:hot_potato, [next | kids], sitter}, :normie) do
    case Potato.check do
      :potato  ->
        IO.write "."
        Child.hot_potato(next, kids, sitter)
      :grenade ->
        IO.write "X"
        Process.exit(sitter, :grenade)
    end

    {:noreply, :normie}
  end

  def handle_cast({:hot_potato, [next | kids], sitter}, :sociopath) do
    case Potato.check do
      :potato  ->
        IO.write ">"
        Potato.poison
        Child.hot_potato(next, kids, sitter)
      :grenade ->
        IO.write "X"
        Process.exit(sitter, :grenade)
    end

    {:noreply, :sociopath}
  end

  def handle_cast({:hot_potato, [], sitter}, type) do
    case Potato.check do
      :potato  ->
        IO.write ","
        Babysitter.play(sitter)
      :grenade ->
        IO.write "X"
        Process.exit(sitter, :grenade)
    end

    {:noreply, type}
  end

  def sociopath?(n), do: Parent.random(n) == 13
end
