defmodule TwitterCloneWeb.UserRestPrivateView do
  use TwitterCloneWeb, :view
  alias TwitterCloneWeb.UserRestPrivateView


  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserRestPrivateView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserRestPrivateView, "user.json")}
  end


  def render("user.json", %{user_rest_private: user}) do
    %{id: user.id, username: user.username}
  end

end
