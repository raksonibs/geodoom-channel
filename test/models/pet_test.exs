defmodule Battledome.PetTest do
  use Battledome.ModelCase

  alias Battledome.Pet

  @valid_attrs %{current_attack: "120.5", current_defence: "120.5", current_health: "120.5", shield: true, state_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Pet.changeset(%Pet{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Pet.changeset(%Pet{}, @invalid_attrs)
    refute changeset.valid?
  end
end
