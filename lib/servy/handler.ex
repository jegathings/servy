defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> route
    |> emojify
    |> format_response
    |> track
    |> IO.write()
  end

  def track(%{status: 404, path: path} = conv) do
    IO.puts("Warning: #{path} is on the loose!")
    conv
  end

  def emojify(%{status: status} = conv) do
    emojies = String.duplicate("🎉", 5)

    case conv do
      %{status: 200} ->
        %{conv | resp_body: "#{emojies} #{conv.resp_body} #{emojies}"}

      _ ->
        conv
    end
  end

  def rewrite_path(%{path: path} = conv) do
    case conv do
      %{path: "/wildlife"} ->
        %{conv | path: "/wildthings"}

      _ ->
        conv
    end
  end

  def parse(request) do
    [method, path, _http] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, resp_body: "", status: nil}
  end

  def route(%{method: "GET", path: path, resp_body: resp_body} = conv) do
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

  def route(%{method: "DELETE", path: path, resp_body: resp_body} = conv) do
    case conv do
      %{path: "/bears", resp_body: ""} ->
        %{conv | status: 403, resp_body: "Deleteing a bear is forbidden."}
    end
  end

  def route(%{method: "GET", path: "/about"} = conv) do
    Path.expand("../../pages", __DIR__)
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  def handle_file({:ok, content}, conv) do
    %{conv | status: 200, resp_body: content}
  end

  def handle_file({:error, :enoent}, conv) do
    %{conv | status: 404, resp_body: "File not found!"}
  end

  def handle_file({:error, reason}, conv) do
    %{conv | status: 500, resp_body: "File error: #{reason}"}
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: 20

    #{conv.resp_body}
    """
  end

  def status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
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
