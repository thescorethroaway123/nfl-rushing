defmodule RushWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `RushWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal RushWeb.PlayerRushLive.FormComponent,
        id: @player_rush.id || :new,
        action: @live_action,
        player_rush: @player_rush,
        return_to: Routes.player_rush_index_path(@socket, :index) %>
  """
  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(RushWeb.ModalComponent, modal_opts)
  end
end
