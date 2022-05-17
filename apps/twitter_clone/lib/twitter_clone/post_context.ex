defmodule TwitterClone.PostContext do
  @moduledoc """
  The PostContext context.
  """

  import Ecto.Query, warn: false
  alias TwitterClone.Repo
  alias TwitterClone.UserContext.User
  alias TwitterClone.PostContext.Post

  def load_posts(%User{} = u) do
    u
    |> Repo.preload([posts: [:likes, :comments]])
  end

  def list_posts do
    Post
    |> Repo.all()
    |> Repo.preload([:user])
    |> Repo.preload([:comments])
    |> Repo.preload([likes: [:user]])
  end

  def get_post!(id) do
    Post
    |> Repo.get!(id)
    |> Repo.preload([:user])
    |> Repo.preload([:comments])
  end

  # list post with given id
  def list_post(id) do
    Post
    |> Repo.get(id)
  end

  def create_post(attrs, %User{} = u) do
    %Post{}
    |> Post.changeset(attrs, u)
    |> Repo.insert()
  end

  def delete_post(%Post{} = post, current_user) do
    unless current_user.role != "Admin" and current_user.id != post.user_id do
      Repo.delete(post)
    else
      {:error, :no_permission}
    end
  end

  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end
end
