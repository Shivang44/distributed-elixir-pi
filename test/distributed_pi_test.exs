defmodule DistributedPiTest do
  use ExUnit.Case
  doctest DistributedPi

  test "greets the world" do
    assert DistributedPi.hello() == :world
  end
end
