defmodule Servy.Handler do
  @pages_path Path.expand("../../pages", __DIR__)

  alias Servy.Conv

  import Servy.Plugins, only: [rewrite_path: 1, track: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.FileHandler, only: [handle_file: 2]

  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> route
    |> track
    |> emojify
    |> format_response
    |> IO.write
  end

  def emojify(%Conv{status: status} = conv) do
    emojies = String.duplicate("🎉", 5)

    case conv do
      %{status: 200} ->
        %{conv | resp_body: "#{emojies} #{conv.resp_body} #{emojies}"}

      _ ->
        conv
    end
  end

  def route(%Conv{method: "GET", path: "/pages/" <> file} = conv) do
    @pages_path
    |> Path.join(file <> ".html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: path, resp_body: resp_body} = conv) do
    case conv do
      %{path: "/wildthings", resp_body: ""} ->
        %{conv | status: 200, resp_body: "Bears, lions, and tigers"}

      %{path: "/mildthings", resp_body: ""} ->
        %{conv | status: 200, resp_body: "Cats, dogs, and hamsters"}

      %{path: "/bears", resp_body: ""} ->
        %{conv | status: 200, resp_body: "Teddy, Smokey, and Paddington"}

      %{path: "/bears?id=" <> id, resp_body: ""} ->
        %{conv | status: 200, resp_body: "Bear #{id}"}

      _ ->
        %{conv | status: 404, resp_body: "No matches for #{path}"}
    end
  end

  def route(%Conv{method: "DELETE", path: path, resp_body: resp_body} = conv) do
    case conv do
      %{path: "/bears", resp_body: ""} ->
        %{conv | status: 403, resp_body: "Deleteing a bear is forbidden."}
    end
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    Path.expand("../../pages", __DIR__)
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: 20

    #{conv.resp_body}
    """
  end
end

# request = """
# GET /wildthings HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*
# """

# response = Servy.Handler.handle(request)

# IO.puts response
