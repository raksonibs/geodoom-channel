defmodule Battledome.PetState do
  use Battledome.Web, :model

  schema "pet_states" do
    field :current_health, :float
    field :current_attack, :float
    field :current_defence, :float
    field :shield, :boolean, default: false

    belongs_to :state, Battledome.State
    belongs_to :pet, Battledome.Pet
    
    timestamps([{:inserted_at,:created_at}])
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:state_id, :current_health, :current_attack, :current_defence, :shield])
    |> validate_required([:state_id, :current_health, :current_attack, :current_defence, :shield])
  end
end
