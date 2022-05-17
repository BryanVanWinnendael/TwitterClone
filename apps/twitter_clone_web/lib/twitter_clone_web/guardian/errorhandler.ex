defmodule TwitterCloneWeb.ErrorHandler do
  import Plug.Conn
  alias Phoenix.Controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    conn
    |> Controller.put_flash(:error, "Please login")
    |> Controller.redirect(to: "/login")
    |> halt
    # body = Jason.encode!(%{message: to_string(type)})
    # send_resp(conn, 401, body)
    # Controller.redirect(to: "/login")
  end
end
