defmodule Rush.Rushing do
  @moduledoc """
    Rushing context
  """

  import Ecto.Query

  alias Rush.Repo
  alias Rush.Rushing.PlayerRush

  def page_count(opts) do
    opts
    |> search_query()
    |> limit(nil)
    |> offset(nil)
    |> Repo.aggregate(:count)
  end

  def search_players(opts) do
    opts
    |> search_query()
    |> Repo.all()
  end

  defp search_query(opts) do
    PlayerRush
    |> apply_ordering(opts)
    |> apply_pagination(opts)
    |> apply_filter(opts)
  end

  defp apply_ordering(query, %{ordering_field: key, ordering_direction: direction}) do
    from(
      player_rushes in query,
      order_by: {^direction, ^key}
    )
  end

  defp apply_ordering(query, _opts), do: query

  defp apply_pagination(query, %{page: page} = opts) when not is_nil(page) do
    page_size = Map.get(opts, :page_size, 10)

    from(
      player_rushes in query,
      limit: ^page_size,
      offset: ^((page - 1) * page_size)
    )
  end

  defp apply_pagination(query, _opts), do: query

  defp apply_filter(query, %{query: nil}), do: query
  defp apply_filter(query, %{query: ""}), do: query

  defp apply_filter(query, %{query: query_input}) do
    from(
      player_rushes in query,
      where: fragment("searchable_player_name @@ to_tsquery(?)", ^prefix_search(query_input))
    )
  end

  defp prefix_search(term), do: String.replace(term, ~r/\W/u, "") <> ":*"
end
