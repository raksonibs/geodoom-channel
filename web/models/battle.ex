defmodule Battledome.Battle do
  use Battledome.Web, :model

  schema "battles" do
    field :name, :string 
    field :status, :integer
    field :winner_id, :integer
    field :loser_id, :integer    

    many_to_many :pets, Battledome.Battle, join_through: "battles_pets"

    timestamps([{:inserted_at,:created_at}])
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
  end
end
