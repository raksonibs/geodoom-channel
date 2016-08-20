defmodule Battledome.State do
  use Battledome.Web, :model

  schema "states" do
    # has_many :pets, Battledome.Pet
    has_many :pet_states, Battledome.PetState
    # field :battle_id, :integer
    field :current_turn, :integer
    belongs_to :battle, Battledome.Battle

    timestamps([{:inserted_at,:created_at}])
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
