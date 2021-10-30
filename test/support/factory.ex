defmodule Rush.Factory do
  use ExMachina.Ecto, repo: Rush.Repo

  alias Faker.{Person, Team}
  alias Rush.Rushing.PlayerRush

  def player_rush_factory do
    %PlayerRush{
      name: "#{Person.first_name()} #{Person.last_name()}",
      team: Team.name(),
      position: "QB",
      avg_attempts_per_game: :rand.uniform(100),
      attempts: Enum.random(0..30),
      total_yards: Enum.random(0..200),
      avg_yards_per_attempt: :rand.uniform(100),
      yards_per_game: :rand.uniform(100),
      touchdowns: Enum.random(0..10),
      longest: Enum.random(1..100),
      longest_is_touchdown: true,
      first_downs: Enum.random(0..20),
      first_downs_percentage: :rand.uniform(100),
      twenty_plus_yards: Enum.random(0..20),
      fourty_plus_yards: Enum.random(0..20),
      fumbles: Enum.random(0..10)
    }
  end
end
