defmodule TwitterCloneWeb.LayoutView do
  use TwitterCloneWeb, :view

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  def active_menu(conn, item) do
    if Atom.to_string(Phoenix.Controller.controller_module(conn)) == item && conn.request_path != "/users", do: "text-xl font-semibold text-gray-800 dark:text-gray-100  mt-4 flex bg-gray-300 dark:bg-gray-800 rounded-md p-2", else: "text-xl font-semibold text-gray-600 dark:text-gray-300  mt-4 flex hover:bg-gray-300 dark:hover:bg-gray-800 rounded-md p-2"
  end

  def active_menu_admin(conn, item) do
    if conn.request_path == "/users" , do: "text-xl font-semibold text-gray-800 dark:text-gray-100  mt-4 flex bg-gray-300 dark:bg-gray-800 rounded-md p-2", else: "text-xl font-semibold text-gray-600 dark:text-gray-300  mt-4 flex hover:bg-gray-300 dark:hover:bg-gray-800 rounded-md p-2"
  end

end
