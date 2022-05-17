defmodule TwitterClone.CommentContext do
  @moduledoc """
  The CommentContext context.
  """

  import Ecto.Query, warn: false
  alias TwitterClone.Repo
  alias TwitterClone.CommentContext.Comment
  alias TwitterClone.PostContext.Post
  alias TwitterClone.UserContext.User


  def create(attrs, %Post{} = p, %User{} = u) do
    %Comment{}
    |> Comment.changeset(attrs, p, u)
    |> Repo.insert()
  end

  def list_comments do
    Repo.all(Comment)
  end

  def get_comments(%Post{} = p) do
    p |> Repo.preload([:comments, :user])
  end

  def list_comments_with_post(post_id) do
    query =
      from comment in Comment,
        join: user in User,
        on: user.id == comment.user_id,
        where: comment.post_id == ^post_id,
        select: %{user: user, comment: comment}

    Repo.all(query)
  end

  def get_comment!(id), do: Repo.get!(Comment, id)

  # def list_comments_with_post(post_id) do
  #   query =
  #     from comment in Comment,
  #       where: comment.post_id == ^post_id
  #   # Comment
  #   Repo.all(query)
  #   # |> Repo.preload([:user])
  # end

  def delete(%Comment{} = comment) do
    Repo.delete(comment)
  end

  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end

end
