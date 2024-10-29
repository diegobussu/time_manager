defmodule TimeManagerApiWeb.TeamController do
  use TimeManagerApiWeb, :controller

  alias TimeManagerApi.Timemanager
  alias TimeManagerApi.Timemanager.Team

  action_fallback TimeManagerApiWeb.FallbackController

  def create(conn, %{"name" => name}) do
    with {:ok, created_team} <- Timemanager.create_team(%{name: name, owner_id: conn.user.id}) do
      team = Timemanager.get_team(created_team.id)
      conn
      send_resp(conn, :accepted, "")
    else
      error -> send_error(conn, "Can't create team")
    end
  end

  def list(conn, _params) do
    case conn.user.rank do
      :manager ->
        teams = Timemanager.get_manager_teams(conn.user.id)
        render(conn, "teams.json", %{teams: teams})
      :general_manager ->
        teams = Timemanager.list_teams()
        render(conn, "teams.json", %{teams: teams})
    end
  end

  def get(conn, %{"id" => id}) do
    user = conn.user

    case Timemanager.get_team(id) do
      nil ->
        send_error(conn, "Team not found")

      team ->
        if Timemanager.is_team_member?(user.id, team) or Timemanager.is_team_owner?(user.id, team) or
          user.rank == :general_manager do
          conn
          |> render("team.json", %{team: team})
        else
          send_resp(conn, :forbidden, "")
        end
    end
  end






  def add_member(conn, %{"id" => id, "user_id" => user_id}) do
    with team <- Timemanager.get_team(id),
         true <- team.owner.id == conn.user.id or conn.user.rank == :general_manager,
         user <- Timemanager.get_user(user_id),
         false <- is_nil(user),
         true <- user.rank == :employee do
      if Enum.any?(team.members, fn member -> member.id == user.id end) do
        send_error(conn, "User is already in this team")
      else
        updated_user = Timemanager.update_user(user, %{team_id: id})
        send_resp(conn, :accepted, "")
      end
    else
      nil -> send_error(conn, "No user found")
      _ -> send_error(conn, "Can't move user to this team")
    end
  end



  def remove_member(conn, %{"id" => id, "user_id" => user_id}) do
    with team <- Timemanager.get_team(id),
         true <- team.owner.id == conn.user.id or conn.user.rank == :general_manager,
         user <- Timemanager.get_user(user_id),
         false <- is_nil(user) do

      if Enum.any?(team.members, fn member -> member.id == user.id end) do
        updated_user = Timemanager.update_user(user, %{team_id: nil})
        send_resp(conn, :accepted, "")
      else
        send_error(conn, "User is not a member of this team")
      end
    else
      nil -> send_error(conn, "User not found")
      _ -> send_error(conn, "Can't remove user from this team")
    end
  end


  def delete(conn, %{"id" => id}) do
    with team <- Timemanager.get_team(id) do
      if is_nil(team) do
        send_error(conn, "Invalid Team ID")
      else
        if team.owner.id == conn.user.id or conn.user.rank == :general_manager do
          Timemanager.delete_team(team)
          send_resp(conn, :accepted, "")
        else
          send_resp(conn, :forbidden, "")
        end
      end
    end
  end

  def update(conn, %{"id" => id, "name" => name}) do
    with team <- Timemanager.get_team(id) do
      if is_nil(team) do
        send_error(conn, "Invalid Team ID")
      else
        if team.owner.id == conn.user.id or conn.user.rank == :general_manager do
          with {:ok, updated_team} <- Timemanager.update_team(team, %{name: name}) do
            send_resp(conn, :accepted, "")
          else
            _ -> send_resp(conn, :no_content, "")
          end
        else
          send_resp(conn, :forbidden, "")
        end
      end
    end
  end

  def send_error(conn, message) do
    conn
    |> put_status(:bad_request)
    |> put_view(TimeManagerApiWeb.ErrorView)
    |> render("error.json", %{error: message})
    |> halt()
  end

end
