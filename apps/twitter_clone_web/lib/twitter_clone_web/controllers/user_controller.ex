defmodule TwitterCloneWeb.UserController do
  use TwitterCloneWeb, :controller

  alias TwitterClone.UserContext
  alias TwitterClone.UserContext.User
  alias TwitterClone.PostContext
  alias TwitterCloneWeb.SessionController
  alias TwitterClone.UserRelationsContext
  alias TwitterClone.UserRelationsContext.UserRelations
  alias TwitterCloneWeb.Guardian

  def index(conn, _params) do
    users = UserContext.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = UserContext.change_new_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case UserContext.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> SessionController.login(%{"user" => %{"username" => user.username, "password" => user.password}})

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn,  %{"id" => id}) do
    user = UserContext.get_user!(id)
    user = PostContext.load_posts(user)
    current_user = Guardian.Plug.current_resource(conn)

    user_info = %{
      followers:  length(UserContext.get_followers!(user.id)),
      following:  length(UserContext.get_following!(user.id)),
      isFollowing: UserRelationsContext.is_following!(current_user.id, user.id)
    }

    render(conn, "show.html",user_info: user_info, user: user, current_user: current_user)
  end

  def editProfile(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    current_user = Guardian.Plug.current_resource(conn)
    changeset = UserContext.change_user(user, current_user)

    if changeset ==  {:error, :no_permission} do
      conn
      |> put_flash(:error, "You are not authorized to edit this user.")
      |> redirect(to: Routes.post_path(conn, :index))
    end

    render(conn, "edit_profile.html", user: user, changeset: changeset)
  end



  def edit(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    current_user = Guardian.Plug.current_resource(conn)
    changeset = UserContext.change_user(user, current_user)

    if changeset ==  {:error, :no_permission} do
      conn
      |> put_flash(:error, "You are not authorized to edit this user.")
      |> redirect(to: Routes.post_path(conn, :index))
    end

    roles = UserContext.get_acceptable_roles()
    render(conn, "edit.html", user: user, changeset: changeset, acceptable_roles: roles)
  end


  def update(conn, %{"id" => id, "user" => user_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    user = UserContext.get_user!(id)

    case UserContext.update_profile(user, user_params, current_user) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Profile updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user.id))

      {:error, :no_permission} ->
        conn
        |> put_flash(:error, "You are not authorized to edit this user.")
        |> redirect(to: Routes.post_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def updateUser(conn, %{"id" => id, "user" => user_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    user = UserContext.get_user!(id)

    case UserContext.update_user(user_params, user, current_user) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :edit,id))

      {:error, :no_permission} ->
        conn
        |> put_flash(:error, "You are not authorized to edit this user.")
        |> redirect(to: Routes.post_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id, "logout" => logout}) do
    user = UserContext.get_user!(id)
    current_user = Guardian.Plug.current_resource(conn)

    case UserContext.delete_user(user, current_user) do
    {:ok, _user} ->
      if logout == "true" do
        conn
        |> put_flash(:info, "User deleted successfully.")
        |> redirect(to: Routes.session_path(conn, :logout))
      end
      conn
      |> put_flash(:info, "User deleted successfully.")
      |> redirect(to: Routes.user_path(conn, :index))

    {:error, :no_permission} ->
      conn
      |> put_flash(:error, "You are not authorized to delete this user.")
      |> redirect(to: Routes.post_path(conn, :index))
    end

  end

  def search(conn, %{"query" => query}) do
    users = UserContext.search(query)

    render(conn, "search.html",users: users)
  end

  def followers(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    followers = UserContext.get_followers!(user.id)

    render(conn, "followers.html",followers: followers, user: user)
  end

  def following(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    following = UserContext.get_following!(user.id)

    render(conn, "following.html", following: following, user: user)
  end


  def create_relation(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)
    user = UserContext.get_user!(id)

    case UserRelationsContext.create_relation(%{"user_id" => current_user.id, "following_id" => user.id}, current_user) do
      {:ok, user_relations} ->
        conn
        |> redirect(to: Routes.user_path(conn, :show, user.id))

    {:error, :no_permission} ->
      conn
      |> put_flash(:error, "You are not authorized to eto do this.")
      |> redirect(to: Routes.post_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |>redirect(to: Routes.user_path(conn, :show, user.id))
    end
  end

  def delete_relation(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)
    user = UserContext.get_user!(id)

    relation = UserRelationsContext.find_relation!(current_user.id, user.id)

    case UserRelationsContext.delete_relation(relation, current_user) do
      {:ok, userRelation} ->
        conn
        |> redirect(to: Routes.user_path(conn, :show, user.id))

      {:error, :no_permission} ->
        conn
        |> put_flash(:error, "You are not authorized to do this.")
        |> redirect(to: Routes.post_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |>redirect(to: Routes.user_path(conn, :show, user.id))
    end
  end

end
