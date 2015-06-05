defmodule PotatoTest do
  use ExUnit.Case

  test "Potato" do
    # Starts as a tater
    {:ok, pid} = Potato.start_link()
    assert :potato == Potato.check(pid)

    # Turn it into a grenade
    Potato.poison(pid)
    assert :grenade == Potato.check(pid)
  end

  test "Parent supervision" do
    {:ok, pid} = Parent.start_link()
  end
end
