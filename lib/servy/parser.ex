defmodule Servy.Parser do
  def parse(request) do
    [method, path, _http] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, resp_body: "", status: nil}
  end
end
