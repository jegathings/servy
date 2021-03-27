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
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=Baloo&type=Brown
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

new_bear = """
GET /bears/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
requests = [wildthings, wildlife, tamethings, bears, bears_id, bearz, new_bear]

menu = fn -> IO.inspect(requests) end

alias Servy.Handler
