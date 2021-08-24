defmodule Elchat.Message.Test do
  use ExUnit.Case
  alias Elchat.Message

  test "message content, author and timestamp are correct" do
    { content, author, time } = { "message content", "german", Time.to_string(Time.utc_now) }
    message = Message.new(content, author, time)
    assert {content, author, time} == { Message.content(message), Message.author(message), Message.timestamp(message) }
  end

  test "message is formatted correctly" do
    message = Message.new("hello!!", "German", "00")
    assert to_string(message) == "German said at 00:\t hello!!"
  end
end
