defmodule Rush.Repo.Migrations.CreatePlayersTable do
  use Ecto.Migration

  def change do
    create table(:player_rushes) do
      add(:name, :string, null: false)
      add(:team, :string)
      add(:position, :string)
      add(:avg_attempts_per_game, :float)
      add(:attempts, :integer)
      add(:total_yards, :integer)
      add(:avg_yards_per_attempt, :float)
      add(:yards_per_game, :float)
      add(:touchdowns, :integer)
      add(:longest, :integer)
      add(:longest_is_touchdown, :boolean, default: false, null: false)
      add(:first_downs, :integer)
      add(:first_downs_percentage, :float)
      add(:twenty_plus_yards, :integer)
      add(:fourty_plus_yards, :integer)
      add(:fumbles, :integer)

      timestamps()
    end

    # Add a way to do indexed searches on player name
    execute("""
      ALTER TABLE player_rushes
      ADD COLUMN searchable_player_name tsvector
      GENERATED ALWAYS AS (
        to_tsvector('english', name)
      ) STORED;
    """)

    execute("""
      CREATE INDEX name_ts_idx ON player_rushes USING GIN (searchable_player_name);
    """)
  end
end
