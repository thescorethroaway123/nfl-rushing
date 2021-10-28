defmodule RushWeb.SortedHeaderComponent do
  use RushWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <th class="sorted-header" phx-click="change_ordering" phx-value-field={@field}">
      <div class="sorted-header-container">
        <div><%= @title %></div>
        <div>
          <%= if @ordering_field == @field do %>
            <%= if @ordering_direction == :asc do %>
              <img class="sort-icon" src={Routes.static_path(RushWeb.Endpoint, "/images/sort-up.svg")}/>
            <% else %>
              <img class="sort-icon" src={Routes.static_path(RushWeb.Endpoint, "/images/sort-down.svg")}/>
            <% end %>
          <% else %>
            <img class="sort-icon" src={Routes.static_path(RushWeb.Endpoint, "/images/no-sort.svg")}/>
          <% end %>
        </div>
      </div>
    </th>
    """
  end
end
