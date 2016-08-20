defmodule Battledome.RoomChannel do
  use Battledome.Web, :channel
  alias Battledome.State
  alias Battledome.Pet
  alias Battledome.Battle
  alias Battledome.PetState
  alias Battledome.User

  require IEx

  def join("room:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("new:message", payload, socket) do
    id = ~r/\d+/
      |> Regex.run(payload["body"]["name"])
      |> Enum.at(0)
      |> Integer.parse
    
    battle_id = elem(id, 0)
    
    state = ( Repo.get_by(State, battle_id: battle_id) ) |> Repo.preload(:pet_states)
    battle = ( Repo.get_by(Battle, id: battle_id) ) |> Repo.preload(:pets)
    user = Repo.get_by(User, email: payload["currentUser"]["email"])

    # NTD: What is the best way to do validation for currentUser.turn and the stateTurn for action?

    message = payload["action"]
      |> execute_action(state, battle, user)

    # want to remove this case
    case message do 
      {:winner, _} -> broadcast socket, "new:winner", payload
      {:ok, _} -> broadcast socket, "new:refresh", payload
      {:ok, %Pet{}} -> broadcast socket, "new:refresh", payload
      {:ok, %State{}} -> broadcast socket, "new:refresh", payload
      {:error, _} -> broadcast socket, "new:error", payload
    end
    # message should be refresh model, or update the actual health
    # refresh easier

    {:noreply, socket}
  end

  def execute_action(event, state, battle, user) do
    current_user = Repo.get_by(User, id: state.current_turn)
    attacker = user |> Repo.preload(:pets)
    pets = attacker.pets
    pet_ids = Enum.map(pets, fn(x) -> x end)
    state_pet_ids = Enum.map(state.pet_states, fn(x) -> x.pet_id end)
    attacker_pet = Enum.find(pet_ids, fn(x) -> Enum.member?(state_pet_ids, x.id) end)
    attacker_pet = attacker_pet |> Repo.preload(:pet_states)
    attacker_pet_state = Enum.find(state.pet_states, fn(x) -> x.pet_id == attacker_pet.id end) |> Repo.preload(:pet)
    defender_pet_state = Enum.find(state.pet_states, fn(x) -> x.pet_id != attacker_pet.id end) |> Repo.preload(:pet)
    defender_pet = defender_pet_state.pet |> Repo.preload(:user)
    defender = defender_pet.user

    case event do 
      "attack" -> 
        attack(attacker, defender, attacker_pet_state, defender_pet_state, state)
      "defend" -> 
        defend(attacker, defender, attacker_pet_state, defender_pet_state, state)
      _ ->
        attack(attacker, defender, attacker_pet_state, defender_pet_state, state)
    end |> calculate_winner(attacker, defender, attacker_pet_state, defender_pet_state, state)
  end

  def calculate_winner(outcome, attacker, defender, attacker_pet_state, defender_pet_state, state) do 
    cond do
      elem(outcome, 1).changes.current_health < 0 -> set_winner(outcome, attacker, defender, attacker_pet_state, defender_pet_state, state)
      true -> {:ok, defender_pet_state}
    end
  end

  def set_winner(outcome, attacker, defender, attacker_pet_state, defender_pet_state, state) do 
    state = state |> Repo.preload(:battle)
    battle = state.battle

    battle = Ecto.Changeset.change battle, status: 2, winner_id: attacker.id, loser_id: defender.id
    
    case Repo.update battle do 
      {:ok, struct} -> update_winner_pet(attacker, attacker_pet_state.pet)
      {:ok, changeset} -> {:error, changeset}
    end
  end

  def update_winner_pet(attacker, attacker_pet) do
    level = attacker_pet.level
    attacker_pet = Ecto.Changeset.change attacker_pet, level: level + 1

    case Repo.update attacker_pet do 
      {:ok, struct} -> {:winner, attacker}
      {:ok, changeset} -> {:error, changeset}
    end
  end

  def attack(attacker, defender, attacker_pet_state, defender_pet_state, state) do    
    new_health = defender_pet_state.current_health - attacker_pet_state.current_attack

    # we are changing the defender's state by attacking with the
    # attacker_pet attack, and then maybe later accounting for defence

    defender_pet_state = Ecto.Changeset.change defender_pet_state, current_health: new_health
    
    case Repo.update defender_pet_state do 
      {:ok, struct} -> update_state({:ok, struct}, state, defender, defender_pet_state)
      {:ok, changeset} -> {:error, changeset}
    end
  end

  def update_state({:ok, struct}, state, new_user, defender_pet_state) do
    state = Ecto.Changeset.change state, current_turn: new_user.id
    
    case Repo.update state do 
      {:ok, struct} -> {:ok, defender_pet_state}
      {:ok, changeset} -> {:error, changeset}
    end
  end

  def defend(attacker, defender, attacker_pet_state, defender_pet_state, state) do 
    new_health = defender_pet_state.current_health + defender_pet_state.current_defence

    # we are changing the defender's state by attacking with the
    # attacker_pet attack, and then maybe later accounting for defence

    defender_pet_state = Ecto.Changeset.change defender_pet_state, current_health: new_health
    
    case Repo.update defender_pet_state do 
      {:ok, struct} -> update_state({:ok, struct}, state, attacker, defender_pet_state)
      {:ok, changeset} -> {:error, changeset}
    end
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
