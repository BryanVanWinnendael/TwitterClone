defmodule TwitterCloneWeb.PageController do
  use TwitterCloneWeb, :controller
  import Plug.Conn
  import Guardian.Plug

  alias TwitterClone.UserContext

  def index(conn, _params) do
    current_user = Plug.Conn.get_session(conn, "current_user")
    users = UserContext.list_users()
    render(conn, "index.html",users: users, current_user: current_user)
  end


  def profile(conn, _params) do
    render(conn, "profile.html")
  end

end
