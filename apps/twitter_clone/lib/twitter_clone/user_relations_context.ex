defmodule TwitterClone.UserRelationsContext do
  @moduledoc """
  The UserContext context.
  """

  import Ecto.Query, warn: false
  alias TwitterClone.Repo
  alias TwitterClone.UserRelationsContext.UserRelations
  alias TwitterClone.UserContext.User

  # see if a user is following another user
  def is_following!(user_id, following_id) do
    query =
      from user_relations in UserRelations,
        where: user_relations.user_id == ^user_id and user_relations.following_id == ^following_id

    Repo.exists?(query)
  end

  # find a relation by user_id and following_id used for delete
  def find_relation!(user_id, id) do
    query =
      from user_relations in UserRelations,
        where: user_relations.user_id == ^user_id and user_relations.following_id == ^id
    Repo.one!(query)
  end

  def create_relation(attrs, current_user) do
    unless current_user.role != "Admin" and current_user.id != attrs["user_id"] do
      %UserRelations{}
      |> UserRelations.changeset(attrs)
      |> Repo.insert()
    else
      {:error, :no_permission}
    end
  end

  def delete_relation(%UserRelations{} = userRelations, current_user) do
    unless current_user.role != "Admin" and current_user.id != userRelations.user_id do
      Repo.delete(userRelations)
    else
      {:error, :no_permission}
    end
  end

end
