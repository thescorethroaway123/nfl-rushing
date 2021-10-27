defmodule Rush.Rushing do
  @moduledoc """
    Rushing context
  """

  import Ecto.Query

  alias Rush.Repo
  alias Rush.Rushing.PlayerRush

  def list_player_rushes do
    Repo.all(PlayerRush)
  end
end
