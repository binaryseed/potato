defmodule Child do
  use GenServer

  def start_link(sitter) do
    GenServer.start_link(__MODULE__, {sociopath?(25), sitter})
  end

  def init({true, sitter}) do
    {:ok, {:sociopath, sitter}}
  end

  def init({false, sitter}) do
    {:ok, {:normie, sitter}}
  end

  def hot_potato(child, kids) do
    :timer.sleep(Parent.random(5, 5))
    GenServer.cast(child, {:hot_potato, kids})
  end

  # Server
  def handle_cast({:hot_potato, [next | kids]}, {:normie, sitter}) do
    case Potato.check do
      :potato  ->
        IO.write "."
        Child.hot_potato(next, kids)
      :grenade ->
        IO.write "X"
        Process.exit(sitter, :grenade)
    end

    {:noreply, {:normie, sitter}}
  end

  def handle_cast({:hot_potato, [next | kids]}, {:sociopath, sitter}) do
    case Potato.check do
      :potato  ->
        IO.write ">"
        Potato.poison
        Child.hot_potato(next, kids)
      :grenade ->
        IO.write "X"
        Process.exit(sitter, :grenade)
    end

    {:noreply, {:sociopath, sitter}}
  end

  def handle_cast({:hot_potato, []}, {type, sitter}) do
    case Potato.check do
      :potato  ->
        IO.write ","
        Babysitter.play(sitter)
      :grenade ->
        IO.write "X"
        Process.exit(sitter, :grenade)
    end

    {:noreply, {type, sitter}}
  end

  def sociopath?(n), do: Parent.random(n) == 13
end
