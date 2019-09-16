defmodule ApiWeb.WorkingtimesView do
  use ApiWeb, :view
  alias ApiWeb.WorkingtimesView

  def render("index.json", %{workingtimes: workingtimes}) do
    %{data: render_many(workingtimes, WorkingtimesView, "workingtimes.json")}
  end

  def render("show.json", %{workingtimes: workingtimes}) do
    %{data: render_one(workingtimes, WorkingtimesView, "workingtimes.json")}
  end

  def render("workingtimes.json", %{workingtimes: workingtimes}) do
    %{id: workingtimes.id,
      start: workingtimes.start,
      end: workingtimes.end,
      user_id: workingtimes.user_id}
  end
end
