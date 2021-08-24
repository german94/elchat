defmodule Elchat.ChatRegistry do
  alias Elchat.UsersRegistry
  alias Elchat.ConversationsRegistry

  defstruct users_registry: UsersRegistry.new(),
            conversations_registry: ConversationsRegistry.new()

  def new() do
    %Elchat.ChatRegistry{}
  end

  def register(registry = %{users_registry: users}, nickname, password) do
    {response, updated_users_registry} = users |> UsersRegistry.register(nickname, password)
    {response, %{registry | users_registry: updated_users_registry}}
  end

  def online_users(%{users_registry: users}) do
    users |> UsersRegistry.list_users
  end

  def start_conversation(registry, {user, password}, participants) do
    errors = credential_errors(registry, user, password) ++ conversation_errors(registry, participants, user)
    registry |> get_or_create_conversation(participants, errors)
  end

  defp credential_errors(%{users_registry: users}, user, password) do
    users
    |> UsersRegistry.credentials_ok?(user, password)
    |> Kernel.!
    |> get_credential_errors
  end

  defp get_credential_errors(_invalid_credentials=true) do
    [:invalid_credentials]
  end

  defp get_credential_errors(_valid_credentials) do
    []
  end

  defp conversation_errors(registry, participants, user) do
    valid_participants?(registry, Enum.concat(participants, [user]))
    |> Kernel.!
    |> get_participants_errors
  end

  defp valid_participants?(registry, participants) do
    participants |> Enum.all?(&Enum.member?(online_users(registry), &1))
  end

  defp get_participants_errors(_invalid_participants=true) do
    [:invalid_participants]
  end

  defp get_participants_errors(_valid_participants) do
    []
  end

  defp get_or_create_conversation(
         registry = %{conversations_registry: conversations, users_registry: users},
         participants,
         _errors = []
       ) do
    {updated_conversations, conversation} =
      ConversationsRegistry.get_or_create_conversation(conversations, users, participants)

    updated_registry = %{registry | conversations_registry: updated_conversations}
    {:ok, updated_registry, conversation}
  end

  defp get_or_create_conversation(registry, _, errors) do
    {{:error, errors}, registry, nil}
  end
end
