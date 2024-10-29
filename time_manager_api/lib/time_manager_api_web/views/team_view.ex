defmodule TimeManagerApiWeb.TeamView do
  use TimeManagerApiWeb, :view
  alias TimeManagerApiWeb.TeamView

  def render("teams.json", %{teams: teams}) do
    render_many(teams, TeamView, "team.json")
  end

  def render("show.json", %{team: team}) do
    render_one(team, TeamView, "team.json")
  end

  def render("created.json", %{team: team}) do
    %{
      id: team.id,
      name: team.name,
      owner: render_one(team.owner, TimeManagerApiWeb.UserView, "user.json", as: :user)
    }
  end

  def render("team.json", %{team: team}) do
    %{
      id: team.id,
      name: team.name,
      owner: render_one(team.owner, TimeManagerApiWeb.UserView, "user.json", as: :user),
      members: render_many(team.members, TimeManagerApiWeb.UserView, "user.json", as: :user),
      updated_at: team.updated_at,
      inserted_at: team.inserted_at
    }
  end

#  def render("teams.json", %{teams: teams}) do
#    render("team.json")
#  end
end
