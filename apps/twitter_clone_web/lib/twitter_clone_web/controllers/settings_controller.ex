defmodule TwitterCloneWeb.SettingsController do
  use TwitterCloneWeb, :controller

  alias TwitterClone.UserContext
  alias TwitterClone.UserContext.User

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    render(conn, "index.html", user: user)
  end

  def language(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    render(conn, "language.html")
  end

  def theme(conn, _params) do
    render(conn, "theme.html")
  end

  def token(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    token = current_user.api_token

    render(conn, "token.html", token: token)
  end

  def generateToken(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    token = Phoenix.Token.sign(
      TwitterCloneWeb.Endpoint,
      "user auth",
      current_user.id
    )

    case UserContext.update_profile(current_user, %{"api_token" => token }, current_user) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Api key succesfully generated.")
        |> redirect(to: Routes.settings_path(conn, :token))

      {:error, :no_permission} ->
        conn
        |> put_flash(:error, "You are not authorized to do this.")
        |> redirect(to: Routes.settings_path(conn, :index))

    end


    render(conn, "token.html", token: token)
  end

end
