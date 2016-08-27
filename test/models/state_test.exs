defmodule Battledome.StateTest do
  use Battledome.ModelCase

  alias Battledome.State

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = State.changeset(%State{}, @valid_attrs)
    assert changeset.valid?
  end
end
