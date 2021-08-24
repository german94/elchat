defmodule Elchat.ChatServer do
  use GenServer
  alias Elchat.ChatRegistry

  def start_link do
    GenServer.start_link(__MODULE__, [], name: Elchat)
  end

  def init(_) do
    {:ok, ChatRegistry.new()}
  end

  def handle_call({:register, nickname, password}, _from, registry) do
    {response, updated_registry} = ChatRegistry.register(registry, nickname, password)
    {:reply, response, updated_registry}
  end

  def handle_call({:online_users}, _from, registry) do
    {:reply, ChatRegistry.online_users(registry), registry}
  end

  def handle_call({:start_conversation, user_credentials, participants}, _from, registry) do
    {response, updated_registry, conversation} =
      ChatRegistry.start_conversation(registry, user_credentials, participants)

    {:reply, {response, conversation}, updated_registry}
  end
end
