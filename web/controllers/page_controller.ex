defmodule Battledome.PageController do
  use Battledome.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
