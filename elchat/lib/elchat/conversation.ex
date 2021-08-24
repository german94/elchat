defmodule Elchat.Conversation do

  defstruct participants: nil, messages: []

  def new(participants) do
    %Elchat.Conversation{
      participants: MapSet.new(participants),
    }
  end

  def add_message(conversation, message) do
    is_participant? = Enum.member?(conversation.participants, message.author)
    do_add_message(conversation, message, is_participant?)
  end

  def participants(%{participants: participants}) do
    participants
  end

  def show(%{messages: messages}) do
    messages
    |> Enum.map_join("\n", &to_string/1)
  end

  defp do_add_message(conversation, message, _valid=true) do
    {:new_message, %Elchat.Conversation{ conversation | messages: conversation.messages ++ [message]}}
  end

  defp do_add_message(conversation, _, _invalid) do
    {:invalid_participant, conversation}
  end

end
