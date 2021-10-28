defmodule RushWeb.PlayerRushLive.Index do
  use RushWeb, :live_view

  alias Rush.Rushing

  @impl true
  def mount(_params, _session, socket) do
    {:ok, initial_assigns(socket)}
  end

  @impl true
  def handle_event("search_by_name", %{"search_field" => %{"query" => query}}, socket) do
    socket =
      socket
      |> assign(:query, query)
      |> put_page_count()
      |> put_player_rushes()

    {:noreply, socket}
  end

  def handle_event("previous_page", _value, %{assigns: %{page: page}} = socket) do
    socket =
      socket
      |> assign(:page, page - 1)
      |> put_player_rushes()

    {:noreply, socket}
  end

  def handle_event("next_page", _value, %{assigns: %{page: page}} = socket) do
    socket =
      socket
      |> assign(:page, page + 1)
      |> put_player_rushes()

    {:noreply, socket}
  end

  def handle_event("change_ordering", %{"field" => field}, socket) do
    ordering_field = String.to_atom(field)
    ordering_direction = ordering_direction(ordering_field, socket.assigns.ordering_field, socket.assigns.ordering_direction)

    socket =
      socket
      |> assign(:ordering_field, ordering_field)
      |> assign(:ordering_direction, ordering_direction)
      |> put_player_rushes()

    {:noreply, socket}
  end

  defp ordering_direction(field, ordering_field, :asc) when field == ordering_field, do: :desc
  defp ordering_direction(field, ordering_field, :desc) when field == ordering_field, do: :asc
  defp ordering_direction(_, _, _), do: :asc

  defp initial_assigns(socket) do
    socket
    |> assign(:page, 1)
    |> assign(:page_size, 10)
    |> assign(:query, nil)
    |> assign(:ordering_field, :name)
    |> assign(:ordering_direction, :asc)
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> put_page_count()
    |> put_player_rushes()
  end

  defp put_player_rushes(%{assigns: %{count: 0}} = socket) do
    assign(socket, :player_rushes, [])
  end

  defp put_player_rushes(socket) do
    assign(socket, :player_rushes, Rushing.search_players(socket.assigns))
  end

  defp put_page_count(socket) do
    page_count = Rushing.page_count(socket.assigns)

    socket
    |> assign(:page_count, page_count)
    |> assign(:page, min(socket.assigns.page, max(page_count, 1)))
  end
end
