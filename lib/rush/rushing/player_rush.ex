defmodule Rush.Rushing.PlayerRush do
  use Ecto.Schema

  schema "player_rushes" do
    field(:name, :string)
    field(:team, :string)
    field(:position, :string)
    field(:avg_attempts_per_game, :float)
    field(:attempts, :integer)
    field(:total_yards, :integer)
    field(:avg_yards_per_attempt, :float)
    field(:yards_per_game, :float)
    field(:touchdowns, :integer)
    field(:longest, :integer)
    field(:longest_is_touchdown, :boolean, default: false)
    field(:first_downs, :integer)
    field(:first_downs_percentage, :float)
    field(:twenty_plus_yards, :integer)
    field(:fourty_plus_yards, :integer)
    field(:fumbles, :integer)

    timestamps()
  end
end
