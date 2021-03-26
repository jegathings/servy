wildthings = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

wildlife = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""
tamethings = """
GET /mildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

bears = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

bears_id = """
GET /bears?id=15 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

bearz = """
GET /bearz HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

requests = fn ->
  """
  wildthings:
  #{wildthings}\n
  wildlife:
  #{wildlife}\n
  tamethings:
  #{tamethings}\n
  bears:
  #{bears}\n
  bears_id:
  #{bears_id}\n
  bearz:
  #{bearz}\n
  """
end

menu = fn -> IO.write(requests.()) end

alias Servy.Handler
