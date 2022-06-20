defmodule TwitterClone.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias TwitterClone.UserContext.User
  alias TwitterClone.PostContext.Post
  alias TwitterClone.CommentContext.Comment
  alias TwitterClone.LikeContext.Like

  @acceptable_roles ["Admin", "User"]

  schema "users" do
    field :date_of_birth, :date
    field :profile_image, :string, default: "https://www.chocolatebayou.org/wp-content/uploads/No-Image-Person-2048x2048.jpeg"
    field :banner_image, :string, default: "https://free4kwallpapers.com/uploads/originals/2020/07/22/minimal-landscape-k-wallpaper.png"
    field :email, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :username, :string
    field :role, :string, default: "User"
    field :api_token, :string, default: "No token yet"
    has_many :posts, Post
    has_many :likes, Like
    has_many :comment, Comment
    many_to_many :users, User, join_through: "user_relations", join_keys: [user_id: :id, following_id: :id]

    timestamps()
  end

  def get_acceptable_roles, do: @acceptable_roles

  defp put_password_hash(
    %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
  ) do
  change(changeset, hashed_password: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :date_of_birth, :email, :profile_image, :banner_image, :api_token])
    |> unique_constraint(:username)
    |> validate_required([:username, :password, :date_of_birth, :email, :api_token])
    |> put_password_hash()
  end

  @doc false
  def changeset_default(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :date_of_birth, :email, :profile_image, :banner_image, :api_token, :role])
    |> unique_constraint(:username)
    |> validate_required([:username, :password, :date_of_birth, :email, :api_token, :role])
    |> validate_inclusion(:role, @acceptable_roles)
    |> put_password_hash()
  end

  @doc false
  def changeset_edit_profile(user, attrs) do
    user
    |> cast(attrs, [:profile_image, :banner_image, :api_token])
  end

  @doc false
  def changeset_edit_account(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :date_of_birth, :email, :profile_image, :banner_image])
    |> unique_constraint(:username)
    |> validate_required([:username, :date_of_birth, :email])
    |> put_password_hash()
  end

  @doc false
  def changeset_edit_account_admin(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :date_of_birth, :email, :profile_image, :banner_image, :role])
    |> unique_constraint(:username)
    |> validate_required([:username, :date_of_birth, :email, :role])
    |> validate_inclusion(:role, @acceptable_roles)
    |> put_password_hash()
  end


end
