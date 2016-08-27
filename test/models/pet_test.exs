defmodule Battledome.PetTest do
  use Battledome.ModelCase

  alias Battledome.Pet

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Pet.changeset(%Pet{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Pet.changeset(%Pet{}, @invalid_attrs)
    assert changeset.valid?
  end
end
