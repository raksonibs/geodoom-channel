defmodule Battledome.StateView do
  use Battledome.Web, :view
  use JaSerializer.PhoenixView

  attributes [:id, :battle_id]
  has_many :pets

  def render("index.json", %{states: states}) do
    %{data: render_many(states, Battledome.StateView, "state.json")}
  end

  def render("show.json", %{state: state}) do
    %{data: render_one(state, Battledome.StateView, "state.json")}
  end

  def render("state.json", %{state: state}) do
    %{id: state.id}
  end
end
