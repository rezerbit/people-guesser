defmodule PeopleGuesserTest do
  use ExUnit.Case
  doctest PeopleGuesser

  test "greets the world" do
    assert PeopleGuesser.hello() == :world
  end
end
