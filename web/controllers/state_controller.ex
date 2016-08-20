defmodule Battledome.StateController do
  use Battledome.Web, :controller

  alias Battledome.State

  def index(conn, _params) do
    states = Repo.all(State)
    render(conn, "index.json", data: states)
  end

  def create(conn, %{"state" => state_params}) do
    changeset = State.changeset(%State{}, state_params)

    case Repo.insert(changeset) do
      {:ok, state} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", state_path(conn, :show, state))
        |> render("show.json", state: state)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Battledome.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    state = Repo.get!(State, id)
    render(conn, "show.json", state: state)
  end

  def update(conn, %{"id" => id, "state" => state_params}) do
    state = Repo.get!(State, id)
    changeset = State.changeset(state, state_params)

    case Repo.update(changeset) do
      {:ok, state} ->
        render(conn, "show.json", state: state)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Battledome.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    state = Repo.get!(State, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(state)

    send_resp(conn, :no_content, "")
  end
end
