defmodule TwitterClone.UserRelationsContext.UserRelations do
  use Ecto.Schema
  import Ecto.Changeset
  alias TwitterClone.UserContext.User

  schema "user_relations" do
    belongs_to :user, User
    belongs_to :following, User
    timestamps()
  end

  @doc false
  def changeset(user_relations, attrs) do
    user_relations
    |> cast(attrs, [:user_id, :following_id])
    |> validate_required([:user_id, :following_id])
  end


end
