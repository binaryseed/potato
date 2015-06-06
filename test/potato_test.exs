defmodule PotatoTest do
  use ExUnit.Case

  test "Potato" do
    # Starts as a tater
    Potato.start_link
    assert :potato == Potato.check

    # Turn it into a grenade
    Potato.poison
    assert :grenade == Potato.check
  end

  test "Parent supervision" do
    Parent.start_link

    :timer.sleep(4000)
  end
end
