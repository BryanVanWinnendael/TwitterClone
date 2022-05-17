defmodule TwitterClone.UserContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TwitterClone.UserContext` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        date_of_birth: ~D[2022-04-06],
        email: "some email",
        hashed_password: "some hashed_password",
        username: "some username"
      })
      |> TwitterClone.UserContext.create_user()

    user
  end
end
