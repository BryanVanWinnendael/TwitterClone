defmodule TwitterCloneWeb.SessionController do
  use TwitterCloneWeb, :controller

  alias TwitterCloneWeb.Guardian
  alias TwitterClone.UserContext
  alias TwitterClone.UserContext.User

  def new(conn, _) do
    changeset = UserContext.change_new_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user do
      redirect(conn, to: "/")
    else
      render(conn, "new.html", changeset: changeset, action: Routes.session_path(conn, :login))
    end
  end

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    UserContext.authenticate_user(username, password)
    |> login_reply(conn)
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> delete_session(:current_user)
    |> redirect(to: "/login")
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, "Welcome back!")
    |> put_session(:current_user, user)
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/")
  end

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> new(%{})
  end
end
