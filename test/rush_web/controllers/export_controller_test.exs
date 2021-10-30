defmodule RushWeb.Controllers.PageControllerTest do
  use RushWeb.ConnCase

  describe "GET /export" do
    test "csv as content-type", %{conn: conn} do
      _player_rushes = insert_list(3, :player_rush)

      players_csv_conn = get(conn, Routes.export_path(conn, :export, ordering_direction: :asc, ordering_field: :name, query: ""))

      assert response_content_type(players_csv_conn, :csv) === "application/csv"
    end

    test "with no query does not filter results", %{conn: conn} do
      _player_rushes = insert_list(3, :player_rush)

      players_csv =
        conn
        |> get(Routes.export_path(conn, :export, ordering_direction: :asc, ordering_field: :name, query: ""))
        |> response(200)
        |> PlayerRushCSV.parse_string(skip_headers: true)

      assert length(players_csv) === 3
    end

    test "with name query filter results by name", %{conn: conn} do
      _searched_player = insert(:player_rush, name: "Tom Brady")
      _other_player = insert(:player_rush, name: "Aaron Rodgers")

      players_csv =
        conn
        |> get(Routes.export_path(conn, :export, ordering_direction: :asc, ordering_field: :name, query: "Tom"))
        |> response(200)
        |> PlayerRushCSV.parse_string(skip_headers: true)

      assert length(players_csv) === 1
    end

    test "with key and direction ordering orders players", %{conn: conn} do
      _most_td_player = insert(:player_rush, name: "Tom Brady", touchdowns: 100)
      _other_player = insert(:player_rush, name: "Aaron Rodgers", touchdowns: 50)

      players_csv =
        conn
        |> get(Routes.export_path(conn, :export, ordering_direction: :desc, ordering_field: :touchdowns, query: ""))
        |> response(200)
        |> PlayerRushCSV.parse_string(skip_headers: true)

      assert length(players_csv) === 2
      assert get_in(players_csv, [Access.at(0), Access.at(0)]) == "\"Tom Brady\""
    end
  end
end
