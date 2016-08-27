defmodule Battledome.Pet do
  use Battledome.Web, :model

  schema "pets" do
    field :colour, :string 
    field :vertices, :integer
    field :level, :integer
    field :name, :string

    many_to_many :battles, Battledome.Battle, join_through: "battles_pets"
    has_many :pet_states, Battledome.PetState
    belongs_to :user, Battledome.User

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
