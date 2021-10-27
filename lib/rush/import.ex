defmodule Rush.Import do
  alias Rush.Repo
  alias Rush.Rushing.PlayerRush

  def import_json_file!(filename) do
    player_rushes =
      filename
      |> File.read!()
      |> Jason.decode!()
      |> Enum.map(&input_to_player_rush/1)

    Repo.insert_all(PlayerRush, player_rushes)
  end

  defp input_to_player_rush(input) do
    {longest, longest_is_touchdown} = parse_longest_rush(input["Lng"])
    now = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

    %{
      name: input["Player"],
      team: input["Team"],
      position: input["Pos"],
      avg_attempts_per_game: parse_float(input["Att/G"]),
      attempts: parse_int(input["Att"]),
      total_yards: parse_int(input["Yds"]),
      avg_yards_per_attempt: parse_float(input["Avg"]),
      yards_per_game: parse_float(input["Yds/G"]),
      touchdowns: parse_int(input["TD"]),
      longest: longest,
      longest_is_touchdown: longest_is_touchdown,
      first_downs: parse_int(input["1st"]),
      first_downs_percentage: parse_float(input["1st%"]),
      twenty_plus_yards: parse_int(input["20+"]),
      fourty_plus_yards: parse_int(input["40+"]),
      fumbles: parse_int(input["FUM"]),
      inserted_at: now,
      updated_at: now
    }
  end

  defp parse_float(value) when is_float(value), do: value
  defp parse_float(value) when is_integer(value), do: value / 1

  defp parse_int(value) when is_integer(value), do: value

  defp parse_int(value) do
    {output, _} = Integer.parse(value)

    output
  end

  defp parse_longest_rush(longest) when is_integer(longest), do: {longest, false}

  defp parse_longest_rush(longest) do
    case Integer.parse(longest) do
      {yards, ""} ->
        {yards, false}

      {yards, "T"} ->
        {yards, true}
    end
  end
end
