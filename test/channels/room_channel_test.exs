defmodule Battledome.RoomChannelTest do
  use Battledome.ChannelCase

  alias Battledome.RoomChannel

  def get_payload do
    payload = %{"action" => "attack",
  "body" => %{"challengedEmail" => "kacper@gmail.com", "challengedPet" => nil,
    "challengedPetId" => nil, "challengerEmail" => "oskar@gmail.com",
    "challengerPet" => %{"colour" => "blue",
      "created_at" => "2016-08-18T00:38:46.466Z", "id" => 27, "level" => 0,
      "name" => "lQSCN", "updated_at" => "2016-08-18T00:38:46.466Z",
      "user_id" => 1, "vertices" => 6}, "challengerPetId" => "27",
    "createdAt" => "2016-08-27", "currentTurn" => 2,
    "currentTurnEmail" => "kacper@gmail.com", "loserEmail" => nil,
    "loserId" => nil, "name" => "Battle number 170", "pets" => ["27"],
    "state" => "153", "status" => "pending", "users" => ["2", "1"],
    "winnerEmail" => nil, "winnerId" => nil},
  "currentUser" => %{"battles" => ["169", "168", "167"],
    "currency" => "USD", "email" => "kacper@gmail.com", "image" => nil,
    "nickname" => nil, "online" => true, "uid" => nil}}
  end

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(RoomChannel, "room:lobby")

    {:ok, socket: socket}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "shout broadcasts to room:lobby", %{socket: socket} do
    push socket, "shout", %{"hello" => "all"}
    assert_broadcast "shout", %{"hello" => "all"}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end

  test "new messages with winners are created", %{socket: socket} do
    payload = get_payload
    ref = push socket, "new:message", payload
    # assert_reply ref, :ok, %{:winner }
    assert_broadcast "new:refresh", payload
  end

  test "new messages with errors are not created", %{socket: socket} do
    payload = %{"action" => "attack",
  "body" => %{"challengedEmail" => "kacper@gmail.com", "challengedPet" => nil,
    "challengedPetId" => nil, "challengerEmail" => nil, "name" => "test"}}
    ref = push socket, "new:message", payload
    # assert_reply ref, :ok, %{:winner }
    assert_broadcast "new:error", payload
  end


  test "execute action with attack", %{socket: socket} do 
    payload = get_payload
    push socket, "shout", %{"hello" => "all"}
    assert_broadcast "shout", %{"hello" => "all"}
  end
end
