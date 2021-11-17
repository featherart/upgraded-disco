defmodule Teacher.CoinDataWorker do
  use GenServer

  @url "https://api.coindesk.com/v1/"

  def start_link(args) do
    id = Map.get(args, :id)
    IO.inspect(id, label: "in startlink")
    GenServer.start_link(__MODULE__, args, name: id)
  end

  def init(state) do
    schedule_coin_fetch()
    {:ok, state}
  end

  def handle_info(:coin_fetch, state) do
    updated_state = state
      |> Map.get(:id)
      |> coin_data()
      |> update_state(state)

    schedule_coin_fetch()
    {:noreply, updated_state}
  end

  defp update_state(%{"rate_float" => price}, existing_state) do
    IO.inspect(existing_state, label: "in update state")
    IO.inspect(price, label: "price")
    Map.merge(existing_state, %{price: price})
  end

  defp coin_data(id) do
    url(id)
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> Jason.decode!()
    |> IO.inspect(label: "coin data:")
    |> Map.get(Atom.to_string(id))
    |> Map.get("USD")
  end

  defp url(id) do
    "#{@url}#{Atom.to_string(id)}/currentprice.json"
  end

  defp schedule_coin_fetch() do
    Process.send_after(self(), :coin_fetch, 5_000)
  end
end
