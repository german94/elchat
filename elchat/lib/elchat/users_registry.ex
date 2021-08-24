defmodule Elchat.UsersRegistry do

  defstruct users: Map.new

  def new do
    %Elchat.UsersRegistry{}
  end

  def register(registry = %{users: users}, nickname, password) do
    already_exists? = Map.has_key?(users, nickname)
    do_register(registry, nickname, password, already_exists?)
  end

  def list_users(%{users: users}) do
    Map.keys(users)
  end

  def credentials_ok?(%{users: users}, user, password) do
    Map.has_key?(users, user) && Map.get(users, user) == password
  end

  defp do_register(registry = %{users: users}, nickname, password, _already_exists=false) do
    {:ok, %{registry | users: Map.put(users, nickname, password)}}
  end

  defp do_register(registry, _, _, _already_exists) do
    {:already_exists, registry}
  end

end
