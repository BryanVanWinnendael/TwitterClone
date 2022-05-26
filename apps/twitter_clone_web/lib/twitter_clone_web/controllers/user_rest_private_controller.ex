defmodule TwitterCloneWeb.UserRestPrivateController do
  use TwitterCloneWeb, :controller

  alias TwitterClone.UserContext
  alias TwitterClone.UserContext.User
  alias TwitterClone.PostContext
  alias TwitterCloneWeb.SessionController
  alias TwitterClone.UserRelationsContext
  alias TwitterClone.UserRelationsContext.UserRelations
  alias TwitterCloneWeb.Plugs.ApiPlug

  action_fallback TwitterCloneWeb.FallbackController

  def index(conn, _params) do
    users = UserContext.list_users()
    render(conn, "index.json", users: users)
  end


  def show(conn, %{"id" => id}) do
    user = UserContext.find_user(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = UserContext.get_user!(id)
    current_user_id = conn.assigns.current_user
    current_user = UserContext.get_user!(current_user_id)

    case UserContext.update_user(user_params, user, current_user) do
      {:ok, user} ->
        conn
        |> put_status(:ok)
        |> render("show.json", user: user)

      {:error, :no_permission} ->
        conn
        |> send_resp(400, "You don't have premission to do this.")

      {:error, _cs} ->
      conn
      |> send_resp(400, "Something went wrong, sorry.")
    end
  end

  def delete(conn, %{"id" => id}) do
    IO.puts("delete")
    current_user_id = conn.assigns.current_user
    IO.puts(current_user_id)
    current_user = UserContext.get_user!(current_user_id)

    user = UserContext.get_user!(id)

    case UserContext.delete_user(user, current_user) do
      {:ok, _user} ->
        conn
        |> put_status(:ok)
        send_resp(conn, :no_content, "")

      {:error, :no_permission} ->
        conn
        |> send_resp(400, "You don't have premission to do this.")

      {:error, _cs} ->
      conn
      |> send_resp(400, "Something went wrong, sorry.")
    end
  end
end
