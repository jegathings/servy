defmodule Servy.Handler do
  @pages_path Path.expand("../../pages", __DIR__)

  alias Servy.Conv
  alias Servy.BearController

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
    |> IO.write()
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

  def route(%Conv{ method: "GET", path: "/api/bears" } = conv) do
    Servy.Api.BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/pages/" <> file} = conv) do
    @pages_path
    |> Path.join(file <> ".html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: path, resp_body: resp_body} = conv) do
    case conv do
      %Conv{path: "/wildthings", resp_body: ""} ->
        %Conv{conv | status: 200, resp_body: "Bears, lions, and tigers"}

      %Conv{path: "/mildthings", resp_body: ""} ->
        %Conv{conv | status: 200, resp_body: "Cats, dogs, and hamsters"}

      %Conv{path: "/bears", resp_body: ""} ->
        BearController.index(conv)
      %Conv{path: "/bears?id=" <> id, resp_body: ""} ->
        params = Map.put(conv.params, "id", id)
        BearController.show(conv, params)
      _ ->
        %Conv{conv | status: 404, resp_body: "No matches for #{path}"}
    end
  end

  def route(%Conv{method: "DELETE", path: path, resp_body: resp_body} = conv) do
    case conv do
      %Conv{path: "/bears", resp_body: ""} ->
        %Conv{conv | status: 403, resp_body: "Deleteing a bear is forbidden."}
    end
  end

  # name=Baloo&type=Brown
  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    Path.expand("../../pages", __DIR__)
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: #{conv.resp_content_type}\r
    Content-Type: text/html\r
    Content-Length: #{String.length(conv.resp_body)}\r
    \r
    #{conv.resp_body}
    """
  end
end
