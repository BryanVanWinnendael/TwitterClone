defmodule TwitterCloneWeb.CommentController do
  use TwitterCloneWeb, :controller

  alias TwitterClone.CommentContext
  alias TwitterClone.UserContext

  alias TwitterClone.PostContext
  alias TwitterClone.UserContext.User


  def create(conn, %{"comment" => comment_params, "id" => post_id, "user_id" => user_id}) do
    post = PostContext.get_post!(post_id)
    posts = PostContext.list_posts()
    user = Guardian.Plug.current_resource(conn)

    case CommentContext.create(comment_params,post, user ) do
      {:ok, post} ->
        conn

        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post_id, user_id: user_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "You must type something before commenting.")
        |>redirect(to: Routes.post_path(conn, :show, post_id))
    end
  end

  def delete(conn, %{"id" => id, "post_id" => post_id, "user_id" => user_id}) do
    user = Guardian.Plug.current_resource(conn)
    comment = CommentContext.get_comment!(id)

    {:ok, _post} = CommentContext.delete(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :show, post_id, user_id: user_id))

  end


end
