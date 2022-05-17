defmodule TwitterClone.PostContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TwitterClone.PostContext` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> TwitterClone.PostContext.create_post()

    post
  end
end
