defmodule Elchat.Message do

  alias Elchat.Message

  defstruct content: "", author: "", timestamp: ""

  def new(content, author, timestamp) do
    %Message{
      content: content,
      author: author,
      timestamp: timestamp,
    }
  end

  def content(%{content: content}) do
    content
  end

  def author(%{author: author}) do
    author
  end

  def timestamp(%{timestamp: timestamp}) do
    timestamp
  end

  defimpl String.Chars, for: Elchat.Message do
    def to_string(message) do
      "#{Message.author(message)}\t said at #{Message.timestamp(message)}:\t #{Message.content(message)}"
    end
  end

end
