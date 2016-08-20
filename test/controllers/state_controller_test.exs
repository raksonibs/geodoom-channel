defmodule Battledome.StateControllerTest do
  use Battledome.ConnCase

  alias Battledome.State
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, state_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    state = Repo.insert! %State{}
    conn = get conn, state_path(conn, :show, state)
    assert json_response(conn, 200)["data"] == %{"id" => state.id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, state_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, state_path(conn, :create), state: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(State, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, state_path(conn, :create), state: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    state = Repo.insert! %State{}
    conn = put conn, state_path(conn, :update, state), state: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(State, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    state = Repo.insert! %State{}
    conn = put conn, state_path(conn, :update, state), state: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    state = Repo.insert! %State{}
    conn = delete conn, state_path(conn, :delete, state)
    assert response(conn, 204)
    refute Repo.get(State, state.id)
  end
end
