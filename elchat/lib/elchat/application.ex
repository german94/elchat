defmodule Elchat.Application do

  use Application

  def start(_type, _args) do
    children = [
      %{
        id: Elchat,
        start: {Elchat.ChatServer, :start_link, []},
      }
    ]
    Supervisor.start_link(children, strategy: :one_for_one)
  end

end
