defmodule BattleshipEngineTest do
  use ExUnit.Case
  doctest BattleshipEngine

  test "greets the world" do
    assert BattleshipEngine.hello() == :world
  end
end
