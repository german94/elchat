defmodule Elchat.ConversationServer do
  use GenServer
  alias Elchat.Conversation
  alias Elchat.Message
  alias Elchat.UsersRegistry

  defstruct conversation: nil, users_registry: nil

  def init([participants, users_registry]) do
    {:ok,
     %Elchat.ConversationServer{
       conversation: Conversation.new(participants),
       users_registry: users_registry
     }}
  end

  def handle_call({:add_message, credentials={user, _password}, content}, _from, state) do
    func = fn -> add_message(state, user, content) end
    handle_authorized_call(state, credentials, func)
  end

  def handle_call({:show, credentials}, _from, state = %{conversation: conversation}) do
    func = fn -> {:reply, Conversation.show(conversation), state} end
    handle_authorized_call(state, credentials, func)
  end

  defp handle_authorized_call(state, {user, password}, func) do
    authorized? = UsersRegistry.credentials_ok?(state.users_registry, user, password)
    do_authorized_action(state, func, authorized?)
  end

  defp do_authorized_action(_, func, _authorized=true) do
    func.()
  end

  defp do_authorized_action(state, _, _unauthorized) do
    {:reply, :unauthorized, state}
  end

  defp create_message(user, content) do
    Message.new(content, user, Time.to_string(Time.utc_now))
  end

  defp add_message(state, user, content) do
    message = create_message(user, content)
    {response, conversation} = Conversation.add_message(state.conversation, message)
    {:reply, response, %{state | conversation: conversation}}
  end

end
