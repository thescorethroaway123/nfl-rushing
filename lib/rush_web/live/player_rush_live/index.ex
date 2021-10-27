defmodule RushWeb.PlayerRushLive.Index do
  use RushWeb, :live_view

  alias Rush.Rushing
  alias Rush.Rushing.PlayerRush

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :player_rushes, list_player_rushes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params), do: socket

  defp list_player_rushes do
    Rushing.list_player_rushes()
  end
end
