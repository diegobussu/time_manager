defmodule TimeManagerApiWeb.WorkingtimesView do
  use TimeManagerApiWeb, :view
  alias TimeManagerApiWeb.WorkingtimesView

  def render("index.json", %{workingtimes: workingtimes}) do
    render_many(workingtimes, WorkingtimesView, "workingtimes.json")
  end

  def render("teams.json", %{workingtimes: workingtimes}) do
    render_many(workingtimes, WorkingtimesView, "team_workingtimes.json")
  end

  def render("show.json", %{workingtimes: workingtimes}) do
    render_one(workingtimes, WorkingtimesView, "workingtimes.json")
  end

  def render("workingtimes.json", %{workingtimes: workingtimes}) do
    %{
      id: workingtimes.id,
      start: workingtimes.start,
      end: workingtimes.end,
    }
  end

  def render("team_workingtimes.json", %{workingtimes: workingtimes}) do
    %{
      id: workingtimes.id,
      start: workingtimes.start,
      end: workingtimes.end,
      user: render_one(workingtimes.user, TimeManagerApiWeb.UserView, "user.json", as: :user),
    }
  end

end
