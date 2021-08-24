defmodule Elchat.UsersRegistry.Test do
  use ExUnit.Case
  alias Elchat.UsersRegistry

  test "empty registry does not have any users" do
    UsersRegistry.new()
    |> UsersRegistry.list_users
    |> Enum.empty?
    |> assert
  end

  test "registry with one user registered lists that user" do
    users = UsersRegistry.new()
    {:ok, users} = UsersRegistry.register(users, "pepito", "bar")
    users
    |> UsersRegistry.list_users
    |> Enum.to_list
    |> assert(["pepito"])
  end

  test "right credentials for existing user are valid" do
    users = UsersRegistry.new()
    {:ok, users} = UsersRegistry.register(users, "pepito", "bar")
    users
    |> UsersRegistry.credentials_ok?("pepito", "bar")
    |> assert
  end

  test "wrong credentials for existing user are invalid" do
    users = UsersRegistry.new()
    {:ok, users} = UsersRegistry.register(users, "pepito", "bar")
    users
    |> UsersRegistry.credentials_ok?("pepito", "baz")
    |> Kernel.!
    |> assert
  end
end
