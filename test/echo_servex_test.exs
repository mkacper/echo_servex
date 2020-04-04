defmodule EchoServexTest do
  use ExUnit.Case
  doctest EchoServex

  test "greets the world" do
    assert EchoServex.hello() == :world
  end
end
