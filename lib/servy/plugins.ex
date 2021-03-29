defmodule Servy.Plugins do
  alias Servy.Conv

  def track(%Conv{status: status, path: path} = conv) do
    case conv do
      %{status: 404} ->
        IO.puts("Warning: #{path} is on the loose!")

      _ ->
        nil
    end

    conv
  end

  def rewrite_path(%Conv{path: path} = conv) do
    case conv do
      %{path: "/wildlife"} ->
        %{conv | path: "/wildthings"}

      _ ->
        conv
    end
  end

  def log(%Conv{} = conv) do
    if Mix.env == :dev do
      IO.inspect conv
    end
    conv
  end
end
