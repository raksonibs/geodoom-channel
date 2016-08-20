defmodule Battledome.User do
  use Battledome.Web, :model

  schema "users" do
    has_many :pets, Battledome.Pet
    field :name, :string
    field :email, :string
    field :currency, :string
    field :online, :boolean

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
