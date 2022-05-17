defmodule TwitterCloneWeb.PostController do
  use TwitterCloneWeb, :controller

  alias TwitterClone.PostContext
  alias TwitterClone.UserContext
  alias TwitterClone.LikeContext

  alias TwitterClone.PostContext.Post
  alias TwitterClone.UserContext.User
  alias TwitterClone.CommentContext.Comment
  alias TwitterClone.CommentContext


  def index(conn, _params) do
    changeset = PostContext.change_post(%Post{})
    posts = PostContext.list_posts()

    render(conn, "index.html", posts: posts, changeset: changeset)
  end

  def new(conn, %{"id" => id}) do
    changeset = PostContext.change_post(%Post{})
    render(conn, "new.html", changeset: changeset, id: id)
  end

  def create(conn, %{"post" => post_params}) do
    user = Guardian.Plug.current_resource(conn)
    posts = PostContext.list_posts()

    case PostContext.create_post(post_params,user) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.post_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "index.html", posts: posts, user: user, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id, "user_id" => user_id}) do
    post = PostContext.get_post!(id)
    user = Guardian.Plug.current_resource(conn)
    changeset = CommentContext.change_comment(%Comment{})
    comments = CommentContext.list_comments_with_post(id)

    render(conn, "show.html", user: user, post: post, changeset: changeset, comments: comments, user_id: user_id)
  end


  def delete(conn, %{"id" => id, "user_id" => user_id}) do
    post = PostContext.get_post!(id)
    current_user = Guardian.Plug.current_resource(conn)

    case PostContext.delete_post(post, current_user) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Post deleted successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user_id))

      {:error, :no_permission} ->
        conn
        |> put_flash(:error, "You are not authorized to delete this post.")
        |> redirect(to: Routes.post_path(conn, :index))
      end
  end


end
