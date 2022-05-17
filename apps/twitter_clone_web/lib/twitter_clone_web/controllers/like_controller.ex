defmodule TwitterCloneWeb.LikeController do
  use TwitterCloneWeb, :controller

  alias TwitterClone.LikeContext
  alias TwitterClone.UserContext

  alias TwitterClone.PostContext
  alias TwitterClone.UserContext.User


  def create(conn, %{"post_id" => id, "user_id" => user_id}) do
    current_user = Guardian.Plug.current_resource(conn)
    post = PostContext.get_post!(id)
    posts = PostContext.list_posts()

    case LikeContext.create(%{"user_id" => current_user.id},post ) do
      {:ok, post} ->
        if user_id == "false" do
          conn
          |> redirect(to: Routes.post_path(conn, :index))
        end
        conn
        |> redirect(to: Routes.user_path(conn, :show, user_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "index.html", changeset: changeset, posts: posts, user: current_user)
    end
  end

  def delete(conn, %{"post_id" => id, "user_id" => user_id}) do
    current_user = Guardian.Plug.current_resource(conn)
    like = LikeContext.find_like!(id, current_user.id)
    posts = PostContext.list_posts()

    case LikeContext.delete(like, current_user) do
      {:ok, post} ->
        if user_id == "false" do
          conn
          |> redirect(to: Routes.post_path(conn, :index))
        end
        conn
        |> redirect(to: Routes.user_path(conn, :show, user_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "index.html", changeset: changeset, posts: posts, user: current_user)
    end

  end

end
