defmodule TwitterClone.UserContextTest do
  use TwitterClone.DataCase

  alias TwitterClone.UserContext

  describe "users" do
    alias TwitterClone.UserContext.User

    import TwitterClone.UserContextFixtures

    @invalid_attrs %{date_of_birth: nil, email: nil, hashed_password: nil, username: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert UserContext.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert UserContext.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{date_of_birth: ~D[2022-04-06], email: "some email", hashed_password: "some hashed_password", username: "some username"}

      assert {:ok, %User{} = user} = UserContext.create_user(valid_attrs)
      assert user.date_of_birth == ~D[2022-04-06]
      assert user.email == "some email"
      assert user.hashed_password == "some hashed_password"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserContext.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{date_of_birth: ~D[2022-04-07], email: "some updated email", hashed_password: "some updated hashed_password", username: "some updated username"}

      assert {:ok, %User{} = user} = UserContext.update_user(user, update_attrs)
      assert user.date_of_birth == ~D[2022-04-07]
      assert user.email == "some updated email"
      assert user.hashed_password == "some updated hashed_password"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = UserContext.update_user(user, @invalid_attrs)
      assert user == UserContext.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = UserContext.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> UserContext.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = UserContext.change_user(user)
    end
  end
end
