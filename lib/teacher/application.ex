defmodule Teacher.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = get_children()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Teacher.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp get_children do
    Enum.map([:btc, :bpi, :featherart, :st23am], fn(user) ->
      Supervisor.child_spec({Teacher.UserDataWorker, %{id: user}}, id: user)
    end)
  end
end
