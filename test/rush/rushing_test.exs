defmodule Rush.RushingTest do
  use Rush.DataCase

  alias Rush.Rushing

  describe "page_count/1" do
    test "returns 0 when empty" do
      opts = %{page: 1, page_size: 10, query: nil, ordering_field: :name, ordering_direction: :asc}

      assert Rushing.page_count(opts) == 0
    end

    test "returns page count" do
      _player_rushes = insert_list(25, :player_rush)
      opts = %{page: 1, page_size: 10, query: nil, ordering_field: :name, ordering_direction: :asc}

      assert Rushing.page_count(opts) == 3
    end
  end

  describe "search_players/1" do
    test "filter players by name" do
      _first_player_rush = insert(:player_rush, name: "Tom Brady")
      _second_player_rush = insert(:player_rush, name: "Drew Brees")
      _third_player_rush = insert(:player_rush, name: "Aaron Rodgers")
      opts = %{page: 1, page_size: 10, query: "Br", ordering_field: :name, ordering_direction: :asc}

      results = Rushing.search_players(opts)

      assert length(results) == 2
    end

    test "ordered players" do
      _first_player_rush = insert(:player_rush, name: "Tom Brady")
      _second_player_rush = insert(:player_rush, name: "Drew Brees")
      _third_player_rush = insert(:player_rush, name: "Aaron Rodgers")
      opts = %{page: 1, page_size: 10, query: nil, ordering_field: :name, ordering_direction: :asc}

      results = Rushing.search_players(opts)

      assert length(results) === 3

      assert get_in(results, [Access.at(0)]).name == "Aaron Rodgers"
      assert get_in(results, [Access.at(1)]).name == "Drew Brees"
      assert get_in(results, [Access.at(2)]).name == "Tom Brady"
    end

    test "paginated players" do
      _player_rushes = insert_list(25, :player_rush)
      opts = %{page: 3, page_size: 10, query: nil, ordering_field: :name, ordering_direction: :asc}

      results = Rushing.search_players(opts)

      assert length(results) === 5
    end

    test "paginated players with page above max" do
      _player_rushes = insert_list(25, :player_rush)
      opts = %{page: 4, page_size: 10, query: nil, ordering_field: :name, ordering_direction: :asc}

      results = Rushing.search_players(opts)

      assert length(results) === 0
    end
  end
end
