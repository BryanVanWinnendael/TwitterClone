defmodule TwitterClone.LikeContext do
  @moduledoc """
  The LikeContext context.
  """

  import Ecto.Query, warn: false
  alias TwitterClone.Repo
  alias TwitterClone.LikeContext.Like
  alias TwitterClone.PostContext.Post


  def create(attrs, %Post{} = p) do
    %Like{}
    |> Like.changeset(attrs, p)
    |> Repo.insert()
  end

  def list_likes do
    Repo.all(Like)
  end

  def delete(%Like{} = like, current_user) do
    unless current_user.role != "Admin" and current_user.id != like.user_id do
      Repo.delete(like)
    else
      {:error, :no_permission}
    end
  end

  def find_like!(post_id, user_id) do
    query =
      from like in Like,
        where: like.post_id == ^post_id and like.user_id == ^user_id
    Repo.one!(query)
  end

  def exists_like!(post_id, user_id) do
    query =
      from like in Like,
        where: like.post_id == ^post_id and like.user_id == ^user_id
    Repo.exists!(query)
  end

  def find_liked_posts(user_id) do
    query =
      from like in Like,
        select: like.post_id,
        where: like.user_id == ^user_id
    Repo.all(query)
  end

end
