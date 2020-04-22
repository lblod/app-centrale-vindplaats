defmodule Dispatcher do
  use Matcher

  define_accept_types []

  match "/sparql", _ do
    forward conn, [], "http://database:8890/sparql"
  end

  last_match
end
