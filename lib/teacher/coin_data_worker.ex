defmodule Teacher.CoinDataWorker do
  use GenServer

  @url = "https://api.coindesk.com/v1/bpi/currentprice.json"

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(state) do
    schedule_coin_fetch()
    {:ok, state}
  end

  def handle_info(:coin_fetch, state) do
    @url
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> IO.inspect(label: "in the pipe")
    |> Jason.decode!()
    |> Map.get("rate")
  end

  defp schedule_coin_fetch() do
    Process.send_after(self(), :coin_fetch, 5_000)
  end
end
