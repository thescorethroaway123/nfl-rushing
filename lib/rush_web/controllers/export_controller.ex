defmodule RushWeb.ExportController do
  use RushWeb, :controller

  alias Rush.Rushing

  NimbleCSV.define(PlayerRushCSV, separator: ~w(; ,), escape: "\0", reserved: ~w(\0 \r\n \n))

  def export(conn, %{"ordering_direction" => direction, "ordering_field" => field, "query" => query}) do
    headers = [
      "Player",
      "Team",
      "Pos",
      "Att/G",
      "Att",
      "Yds",
      "Avg",
      "Yds/G",
      "TD",
      "Lng",
      "1st",
      "1st%",
      "20+",
      "40+",
      "FUM"
    ]

    search_opts = %{
      ordering_direction: String.to_atom(direction),
      ordering_field: String.to_atom(field),
      query: query
    }

    player_rushes =
      Enum.map(
        Rushing.search_players(search_opts),
        &build_exported_player_rush/1
      )

    csv_text = PlayerRushCSV.dump_to_iodata([headers | player_rushes])

    send_download(
      conn,
      {:binary, csv_text},
      content_type: "application/csv",
      filename: "player_rushes.csv"
    )
  end

  defp build_exported_player_rush(player_rush) do
    longest = longest_with_suffix(player_rush.longest, player_rush.longest_is_touchdown)

    [
      ~s("#{player_rush.name}"),
      ~s("#{player_rush.team}"),
      ~s("#{player_rush.position}"),
      ~s("#{player_rush.avg_attempts_per_game}"),
      ~s("#{player_rush.attempts}"),
      ~s("#{player_rush.total_yards}"),
      ~s("#{player_rush.avg_yards_per_attempt}"),
      ~s("#{player_rush.yards_per_game}"),
      ~s("#{player_rush.touchdowns}"),
      ~s("#{longest}"),
      ~s("#{player_rush.first_downs}"),
      ~s("#{player_rush.first_downs_percentage}"),
      ~s("#{player_rush.twenty_plus_yards}"),
      ~s("#{player_rush.fourty_plus_yards}"),
      ~s("#{player_rush.fumbles}")
    ]
  end

  defp longest_with_suffix(longest, true), do: "#{longest}T"
  defp longest_with_suffix(longest, _), do: "#{longest}"
end
