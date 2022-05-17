defmodule TwitterCloneWeb.UserRestPublicView do
  use TwitterCloneWeb, :view
  alias TwitterCloneWeb.UserRestPublicView


  # def render("index.json", %{users: users}) do
  #   %{data: render_many(users, UserRestPublicView, "user.json")}
  # end

  # def render("user.json", %{user: user}) do
  #   %{id: user.id, name: user.username}
  # end

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserRestPublicView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserRestPublicView, "user.json")}
  end

  def render("user.json", %{user_rest_public: user}) do
    %{
      id: user.id,
      username: user.username,
      date_birth: user.date_of_birth,
      profile_image: user.profile_image,
    }
  end

end
