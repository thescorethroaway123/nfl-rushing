defmodule RushWeb.PlayerRushLiveTest do
  use RushWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "Index" do
    setup do
      player_rushes = insert_list(25, :player_rush)

      {:ok, player_rushes: player_rushes}
    end

    test "renders player rushes", %{conn: conn, player_rushes: _player_rushes} do
      {:ok, _index_live, html} = live(conn, Routes.player_rush_index_path(conn, :index))

      assert html =~ "Player Rushes"
      assert html =~ "Page 1 of 3"

      assert length(Floki.find(html, ".player-rush")) === 10
    end

    test "updates player_rushes when changing page", %{conn: conn, player_rushes: _player_rushes} do
      {:ok, index_live, _html} = live(conn, Routes.player_rush_index_path(conn, :index))

      new_table =
        index_live
        |> element(".next-button")
        |> render_click()

      assert new_table =~ "Page 2 of 3"

      IO.inspect(new_table)
    end
  end
end
