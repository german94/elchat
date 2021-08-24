defmodule Elchat do
  def register(nickname, password) do
    GenServer.call(Elchat, {:register, nickname, password})
  end

  def online_users() do
    GenServer.call(Elchat, {:online_users})
  end

  def start_conversation(user_credentials, participants) do
    GenServer.call(Elchat, {:start_conversation, user_credentials, participants})
  end

  def send_message(conversation, user_credentials, content) do
    GenServer.call(conversation, {:add_message, user_credentials, content})
  end

  def show_conversation(conversation, user_credentials) do
    GenServer.call(conversation, {:show, user_credentials})
    |> IO.puts
  end
end
