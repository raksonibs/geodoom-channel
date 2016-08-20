defmodule Battledome.PetView do
  use Battledome.Web, :view

  def render("index.json", %{pets: pets}) do
    %{data: render_many(pets, Battledome.PetView, "pet.json")}
  end

  def render("show.json", %{pet: pet}) do
    %{data: render_one(pet, Battledome.PetView, "pet.json")}
  end

  def render("pet.json", %{pet: pet}) do
    %{id: pet.id,
      state_id: pet.state_id,
      current_health: pet.current_health,
      current_attack: pet.current_attack,
      current_defence: pet.current_defence,
      shield: pet.shield}
  end
end
