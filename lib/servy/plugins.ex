defmodule Servy.Plugins do
  def track(%{status: status, path: path} = conv) do
    case conv do
      %{status: 404} ->
        IO.puts("Warning: #{path} is on the loose!")

      _ ->
        nil
    end

    conv
  end

  def rewrite_path(%{path: path} = conv) do
    case conv do
      %{path: "/wildlife"} ->
        %{conv | path: "/wildthings"}

      _ ->
        conv
    end
  end
end
