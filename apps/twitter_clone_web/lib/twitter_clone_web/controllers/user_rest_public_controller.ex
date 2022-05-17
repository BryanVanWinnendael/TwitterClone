defmodule TwitterCloneWeb.UserRestPublicController do
  use TwitterCloneWeb, :controller

  alias TwitterClone.UserContext
  alias TwitterClone.UserContext.User
  alias TwitterClone.PostContext
  alias TwitterCloneWeb.SessionController
  alias TwitterClone.UserRelationsContext
  alias TwitterClone.UserRelationsContext.UserRelations

  action_fallback TwitterCloneWeb.FallbackController

  def index(conn, _params) do
    users = UserContext.list_users()
    render(conn, "index.json", users: users)
  end


  def show(conn, %{"id" => id}) do
    user = UserContext.find_user(id)
    render(conn, "show.json", user: user)
  end

  def create(conn, %{"user" => user_params}) do
    case UserContext.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.user_path(conn, :show, user.id))
        |> render("show.json", user: user)

        {:error, _cs} ->
        conn
        |> send_resp(400, "Something went wrong, sorry.")
    end
  end


end
