defmodule TimeManagerApiWeb.UserController do
  use TimeManagerApiWeb, :controller

  alias TimeManagerApi.Timemanager
  alias TimeManagerApi.Timemanager.User

  action_fallback TimeManagerApiWeb.FallbackController

  import TimeManagerApiWeb.Router

  plug :is_manager when action in [:list, :delete, :update, :get]
  plug :is_general_manager when action in [:reset_password_user]

  def list(conn, %{"email" => email}) do
    users = Timemanager.find_user_by_email(email)
    render(conn, "index.json", users: users)
  end

  def list(conn, %{"firstname" => firstname, "lastname" => lastname}) do
    users = Timemanager.find_user_by_names(firstname, lastname)
    render(conn, "index.json", users: users)
  end

  def list(conn, params) do
    users = Timemanager.list_users()
    render(conn, "index.json", users: users)
  end

  def get(conn, %{"id" => id}) do
    user = Timemanager.get_user!(id)
    render(conn, "manager.json", user: user)
  end

  def get_me(conn, _params) do
    render(conn, "user.json", user: conn.user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Timemanager.get_user!(id)

    if user.rank == :general_manager do
      send_resp(conn, :forbidden, "")
    else
      with {:ok, %User{} = user} <- Timemanager.update_user(user, user_params) do
        send_resp(conn, :accepted, "")
      end
    end
  end

  def update_me(conn, %{"user" => user_params}) do
    user = conn.user
    with {:ok, %User{} = user} <- Timemanager.update_user(user, user_params) do
      send_resp(conn, :accepted, "")
    end
  end

  def delete_me(conn, _params) do
    Timemanager.delete_user(conn.user);
    send_resp(conn, :accepted, "")
  end

  def delete(conn, %{"id" => id}) do
    user = Timemanager.get_user!(id)

    if user.rank == :general_manager do
      send_resp(conn, :forbidden, "")
    else
      with {:ok, %User{}} <- Timemanager.delete_user(user) do
        send_resp(conn, :no_content, "")
      end
    end
  end

  def reset_password(conn, %{"new_password" => new_password, "last_password" => last_password}) do
    cond do
      new_password == "" ->
        send_error(conn, "New password can't be empty")

      String.length(new_password) < 8 ->
        send_error(conn, "New password must be at least 8 characters long")

      true ->
        with true <- TimeManagerApi.Auth.verify(conn.user, last_password) do
          Timemanager.update_user(conn.user, %{password: TimeManagerApi.Auth.hash_password(new_password)})
          send_resp(conn, :accepted, "")
        else
          false ->
            send_error(conn, "Invalid old password")
        end
    end
  end



  def reset_password_user(conn, %{"id" => id, "new_password" => new_password}) do
    cond do
      new_password == "" ->
        send_error(conn, "New password can't be empty")

      String.length(new_password) < 8 ->
        send_error(conn, "New password must be at least 8 characters long")

      true ->
        with %User{} = user <- Timemanager.get_user(id) do
          if user.rank == :general_manager do
            send_error(conn, "You can't reset the password for a general manager")
          else
            Timemanager.update_user(user, %{password: TimeManagerApi.Auth.hash_password(new_password)})
            send_resp(conn, :accepted, "")
          end
        else
          _ ->
            send_error(conn, "Invalid user id")
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
