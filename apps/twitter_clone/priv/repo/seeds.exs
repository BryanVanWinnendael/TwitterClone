# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TwitterClone.Repo.insert!(%TwitterClone.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
{:ok, _cs} =
  TwitterClone.UserContext.create_user(%{"password" => "test", "username" => "test", "email" => "test@test.com", "role" => "User", "date_of_birth" => "2000-01-01"})
{:ok, _cs} =
  TwitterClone.UserContext.create_user(%{"password" => "test", "username" => "test2", "email" => "test2@test2.com", "role" => "User", "date_of_birth" => "2000-01-01"})
{:ok, _cs} =
    TwitterClone.UserContext.create_user(%{"password" => "admin", "username" => "admin", "email" => "admin@admin.com", "role" => "Admin", "date_of_birth" => "2000-01-01"})
