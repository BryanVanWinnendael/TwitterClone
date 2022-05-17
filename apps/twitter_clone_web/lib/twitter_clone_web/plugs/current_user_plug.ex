defmodule TwitterCloneWeb.Plugs.CurrentUserPlug do
  import Plug.Conn
  alias TwitterClone.UserContext.User
  alias TwitterClone.UserContext

  alias Phoenix.Controller

  def init(options), do: options

  def call(conn, _opts) do

    current_user = Plug.Conn.get_session(conn, "current_user")

    if current_user do
      conn
      |> assign(:current_user, current_user)
      |> assign(:logged_in?, true)

    else
      conn
      |> assign(:logged_in?, false)
    end
  end

end
