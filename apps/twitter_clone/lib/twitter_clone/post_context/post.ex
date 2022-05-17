defmodule TwitterClone.PostContext.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias TwitterClone.UserContext.User
  alias TwitterClone.LikeContext.Like
  alias TwitterClone.CommentContext.Comment


  schema "posts" do
    field :content, :string
    belongs_to :user, User
    has_many :likes, Like
    has_many :comments, Comment
    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end

  @doc false
  def changeset(post, attrs, user) do
    post
    |> cast(attrs, [:content])
    |> validate_required([:content])
    |> put_assoc(:user, user)
  end

end
