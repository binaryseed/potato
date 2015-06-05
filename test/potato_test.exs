defmodule PotatoTest do
  use ExUnit.Case

  test "Potato" do
    # Starts as a tater
    {:ok, pid} = Potato.start()
    assert :potato == Potato.check(pid)

    # Turn it into a grenade
    Potato.poison(pid)
    assert :grenade == Potato.check(pid)
  end
end
