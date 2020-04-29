defmodule Dispatcher do
  use Matcher

  define_accept_types [
    json: [ "application/json", "application/vnd.api+json" ],
    html: [ "text/html", "application/xhtml+html" ],
    any: [ "*/*" ]
  ]

  @html %{ accept: %{ html: true } }
  @json %{ accept: %{ json: true } }
  @any %{ accept: %{ any: true } }

  options "*path", _ do
    conn
    |> Plug.Conn.put_resp_header( "access-control-allow-headers", "content-type,accept" )
    |> Plug.Conn.put_resp_header( "access-control-allow-methods", "*" )
    |> send_resp( 200, "{ \"message\": \"ok\" }" )
  end

  get "/favicon.ico", @any do
    send_resp( conn, 404, "" )
  end

  get "/assets/*path", @any do
    forward conn, path, "http://frontend/assets/"
  end

  match "/uri-info/*path", @any do
    forward conn, path, "http://uriinfo/"
  end

  match "/*_path", @html do
    # *_path allows a path to be supplied, but will not yield
    # an error that we don't use the path variable.
    forward conn, [], "http://frontend/index.html"
  end

  match "/sparql", @any do
    forward conn, [], "http://database:8890/sparql"
  end

  match "_", %{ last_call: true, accept: %{ json: true } } do
    send_resp( conn, 404, "{ \"error\": { \"code\": 404, \"message\": \"Route not found.  See config/dispatcher.ex\" } }" )
  end

  match "_", %{ last_call: true, accept: %{ any: true } } do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end

  last_match
end
