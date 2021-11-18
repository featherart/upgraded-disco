defmodule Teacher.UserDataWorker do
  use GenServer

  alias Teacher.UserData

  def start_link(args) do
    id = Map.get(args, :id)
    GenServer.start_link(__MODULE__, args, name: id)
  end

  def init(state) do
    schedule_user_fetch()
    {:ok, state}
  end

  def handle_info(:user_fetch, state) do
    updated_state = state
      |> Map.get(:id)
      |> UserData.fetch()
      |> update_state(state)

    IO.inspect("Current search: #{Atom.to_string(updated_state[:id])}, name: #{updated_state[:name]}")
    IO.inspect("Avatar: #{updated_state[:img]}")

    schedule_user_fetch()
    {:noreply, updated_state}
  end

  defp update_state(new_state, existing_state) do
    %{"name" => name, "avatar_url" => img} = new_state
    Map.merge(existing_state, %{name: name, img: img})
  end

  
  defp schedule_user_fetch() do
    Process.send_after(self(), :user_fetch, 5_000)
  end
end
