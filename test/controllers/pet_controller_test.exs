defmodule Battledome.PetControllerTest do
  use Battledome.ConnCase

  alias Battledome.Pet
  @valid_attrs %{current_attack: "120.5", current_defence: "120.5", current_health: "120.5", shield: true, state_id: 42}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, pet_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    pet = Repo.insert! %Pet{}
    conn = get conn, pet_path(conn, :show, pet)
    assert json_response(conn, 200)["data"] == %{"id" => pet.id,
      "state_id" => pet.state_id,
      "current_health" => pet.current_health,
      "current_attack" => pet.current_attack,
      "current_defence" => pet.current_defence,
      "shield" => pet.shield}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, pet_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, pet_path(conn, :create), pet: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Pet, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, pet_path(conn, :create), pet: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    pet = Repo.insert! %Pet{}
    conn = put conn, pet_path(conn, :update, pet), pet: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Pet, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    pet = Repo.insert! %Pet{}
    conn = put conn, pet_path(conn, :update, pet), pet: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    pet = Repo.insert! %Pet{}
    conn = delete conn, pet_path(conn, :delete, pet)
    assert response(conn, 204)
    refute Repo.get(Pet, pet.id)
  end
end
