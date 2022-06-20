defmodule TwitterClone.UserContext do
  @moduledoc """
  The UserContext context.
  """

  import Ecto.Query, warn: false
  alias TwitterClone.Repo
  alias TwitterClone.UserRelationsContext.UserRelations
  alias TwitterClone.UserContext.User

  def list_users do
    Repo.all(User)
  end

  def list_users_load() do
      User
      |> Repo.all()
      |> Repo.preload([:posts])
  end


  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  def get_user_by_username(username) do
    query =
      from user in User,
        where: user.username == ^username
    Repo.one!(query)
  end

  def get_followers!(id) do
    query =
      from user in User,
        join: user_relations in UserRelations,
        on: user_relations.user_id == user.id,
        where: user_relations.following_id == ^id,
        select: %{user: user, user_relations: user_relations}
    Repo.all(query)
  end

  def get_following!(id) do
    query =
      from user in User,
        join: user_relations in UserRelations,
        on: user_relations.following_id == user.id,
        where: user_relations.user_id == ^id,
        select: %{user: user, user_relations: user_relations}
    Repo.all(query)
  end


  def authenticate_user(username, plain_text_password) do
    case Repo.get_by(User, username: username) do
      nil ->
        Argon2.no_user_verify()
        {:error, "invalid crediantials"}

      user ->
        if Argon2.verify_pass(plain_text_password, user.hashed_password) do
          {:ok, user}
        else
          {:error, "invalid crediantials"}
        end
    end
  end


  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def create_user_default(attrs \\ %{}) do
    %User{}
    |> User.changeset_default(attrs)
    |> Repo.insert()
  end


  defdelegate get_acceptable_roles(), to: User

  def update_user(attrs, %User{} = user, current_user) do
    unless current_user.role != "Admin" and current_user.id != user.id do
      if current_user.role == "Admin" do
        user
        |> User.changeset_edit_account_admin(attrs)
        |> Repo.update()
      else
        user
        |> User.changeset_edit_account(attrs)
        |> Repo.update()
      end
    else
      {:error, :no_permission}
    end

  end

  def update_profile(%User{} = user, attrs, current_user) do
    unless current_user.role != "Admin" and current_user.id != user.id do
      user
      |> User.changeset_edit_profile(attrs)
      |> Repo.update()
    else
      {:error, :no_permission}
    end
  end

  def search(param) do
    wildcard_search = "%#{param}%"
    query =
      from user in User,
        where: like(user.username, ^wildcard_search)
    Repo.all(query)
  end

  defdelegate get_acceptable_roles(), to: User


  def delete_user(%User{} = user, current_user) do

    unless current_user.role != "Admin" and current_user.id != user.id do
      Repo.delete(user)
    else
      {:error, :no_permission}
    end
  end

  def change_user_account( %User{} = user, current_user, attrs \\ %{} ) do
    unless current_user.role != "Admin" and current_user.id != user.id do
      User.changeset_edit_account(user, attrs)
    else
      {:error, :no_permission}
    end
  end

  def change_user_profile( %User{} = user, current_user, attrs \\ %{} ) do
    unless current_user.role != "Admin" and current_user.id != user.id do
      User.changeset_edit_profile(user, attrs)
    else
      {:error, :no_permission}
    end
  end


  def change_new_user(attrs \\ %{}, %User{} = user) do
    User.changeset(user, attrs)
  end

end
