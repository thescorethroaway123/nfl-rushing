defmodule RushWeb.PaginationComponent do
  use RushWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="pagination">
      <%= if @page == 1 do %>
        <button class="pagination-button previous-button" phx-click="previous_page" disabled><%= gettext "Previous" %></button>
      <% else %>
        <button class="pagination-button previous-button" phx-click="previous_page"><%= gettext "Previous" %></button>
      <% end %>

      <div class="pagination-text"><%= gettext "Page %{page} of %{page_count}", page: @page, page_count: @page_count %></div>

      <%= if @page == @page_count do %>
        <button class="pagination-button next-button" phx-click="next_page" disabled><%= gettext "Next" %></button>
      <% else %>
        <button class="pagination-button next-button" phx-click="next_page"><%= gettext "Next" %></button>
      <% end %>
    </div>
    """
  end
end
