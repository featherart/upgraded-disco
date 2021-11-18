defmodule Teacher.UserData do

  @url "https://api.github.com/users/"

  def fetch(id) do
    url(id)
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> Jason.decode!()
  end

  defp url(id) do
    "#{@url}#{id}"
  end

end
