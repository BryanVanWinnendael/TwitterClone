defmodule TwitterCloneWeb.LayoutView do
  use TwitterCloneWeb, :view

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  def is_active_home(conn) do
    Phoenix.Controller.controller_module(conn) == TwitterCloneWeb.PageController
  end

  def is_active_profile(conn) do
    Phoenix.Controller.controller_module(conn) == TwitterCloneWeb.UserController
  end

end
