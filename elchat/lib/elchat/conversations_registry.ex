defmodule Elchat.ConversationsRegistry do
  alias Elchat.ConversationsRegistry

  defstruct conversations: Map.new()

  def new do
    %Elchat.ConversationsRegistry{}
  end

  def get_or_create_conversation(registry, users_registry, participants) do
    conversation_id = generate_conversation_id(participants)
    conversation = Map.get(registry.conversations, conversation_id, false)
    do_get_or_create(registry, users_registry, participants, conversation)
  end

  defp do_get_or_create(registry, users_registry, participants, _conversation_exists = false) do
    create_conversation(registry, users_registry, participants)
  end

  defp do_get_or_create(registry, _, _, conversation) do
    {registry, conversation}
  end

  defp create_conversation(registry, users_registry, participants) do
    {:ok, conversation_pid} = GenServer.start_link(Elchat.ConversationServer, [participants, users_registry])
    conversation_id = generate_conversation_id(participants)
    updated_registry = add_conversation(registry, conversation_id, conversation_pid)
    {updated_registry, conversation_pid}
  end

  defp add_conversation(registry, conversation_id, conversation_pid) do
    %ConversationsRegistry{
      registry
      | conversations: Map.put(registry.conversations, conversation_id, conversation_pid)
    }
  end

  defp generate_conversation_id(participants) do
    participants
    |> Enum.sort()
    |> join_participants
    |> obfuscate
  end

  defp obfuscate(str) do
    :crypto.hash(:md5, str)
    |> Base.encode64()
  end

  defp join_participants(participants) do
    Enum.reduce(participants, &"#{&2}.#{&1}")
  end
end
