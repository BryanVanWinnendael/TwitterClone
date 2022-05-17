defmodule TwitterClone.CommentContext.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias TwitterClone.PostContext.Post
  alias TwitterClone.UserContext.User

  schema "comments" do
    field :content, :string
    belongs_to :post, Post
    belongs_to :user, User
    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end


  @doc false
  def changeset(comment, attrs, post, user) do
    comment
    |> cast(attrs, [:content])
    |> validate_required([:content])
    |> put_assoc(:post, post)
    |> put_assoc(:user, user)
  end


end
