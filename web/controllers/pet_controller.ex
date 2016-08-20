defmodule Battledome.PetController do
  use Battledome.Web, :controller

  alias Battledome.Pet

  def index(conn, _params) do
    pets = Repo.all(Pet)
    render(conn, "index.json", pets: pets)
  end

  def create(conn, %{"pet" => pet_params}) do
    changeset = Pet.changeset(%Pet{}, pet_params)

    case Repo.insert(changeset) do
      {:ok, pet} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", pet_path(conn, :show, pet))
        |> render("show.json", pet: pet)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Battledome.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    pet = Repo.get!(Pet, id)
    render(conn, "show.json", pet: pet)
  end

  def update(conn, %{"id" => id, "pet" => pet_params}) do
    pet = Repo.get!(Pet, id)
    changeset = Pet.changeset(pet, pet_params)

    case Repo.update(changeset) do
      {:ok, pet} ->
        render(conn, "show.json", pet: pet)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Battledome.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    pet = Repo.get!(Pet, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(pet)

    send_resp(conn, :no_content, "")
  end
end
