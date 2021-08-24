defmodule Elchat.Conversation.Test do
  use ExUnit.Case
  alias Elchat.Conversation

  test "all participants are in the conversation" do
    participants = ["german", "nani"]
    conversation = Conversation.new(participants)
    assert participants -- (conversation |> Conversation.participants |> Enum.to_list)
  end

  test "there are no others participants in the conversation" do
    participants = ["german", "nani"]
    conversation = Conversation.new(participants)
    assert (conversation |> Conversation.participants |> Enum.to_list) -- participants
  end

  test "new conversation has no messages" do
    Conversation.new(["german", "nani"])
    |> Conversation.show()
    |> assert("")
  end

  test "conversation with valid message is correctly shown" do
    message = Elchat.Message.new("hola!", "german", "00")
    conversation = Conversation.new(["german"])
    {:new_message, conversation} = Conversation.add_message(conversation, message)
    conversation
    |> Conversation.show
    |> assert("German said at 00: hola!")
  end

  test "conversation with invalid message remains the same" do
    message = Elchat.Message.new("hola!", "pepito", "00")
    conversation = Conversation.new(["german"])
    shows_before = ""
    {:invalid_participant, conversation} = Conversation.add_message(conversation, message)
    conversation
    |> Conversation.show
    |> assert(shows_before)
  end

  test "conversation with two messages is correctly shown" do
    conversation = Conversation.new(["german", "nani"])
    {:new_message, conversation} = Conversation.add_message(conversation, Elchat.Message.new("hola!", "german", "00"))
    {:new_message, conversation} = Conversation.add_message(conversation, Elchat.Message.new("oliii", "nani", "01"))
    conversation
    |> Conversation.show
    |> assert("German said at 00: hola!\nnani said at 01: oliii")
  end
end
