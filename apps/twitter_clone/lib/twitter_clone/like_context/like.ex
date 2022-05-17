defmodule TwitterClone.LikeContext.Like do
  use Ecto.Schema
  import Ecto.Changeset
  alias TwitterClone.PostContext.Post
  alias TwitterClone.UserContext.User


  schema "likes" do
    belongs_to :user, User
    belongs_to :post, Post

    timestamps()
  end

  @doc false
  def changeset(like, attrs) do
    like
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
  end

  @doc false
  def changeset(like, attrs, post) do
    like
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
    |> put_assoc(:post, post)
  end

end
