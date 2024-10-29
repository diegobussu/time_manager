defmodule TimeManagerApiWeb.AuthController do
  use TimeManagerApiWeb, :controller
  alias TimeManagerApi.Timemanager
  alias TimeManagerApi.Timemanager.User

  def register(conn, user_params) do
    user = TimeManagerApi.Timemanager.get_user_by_email(user_params["email"])

    if String.length(user_params["password"]) < 8 do
      conn
      |> send_resp(:bad_request, "The password must be at least 8 characters long.")
    else
      if is_nil(user) do
        with {:ok, %User{} = user} <- Timemanager.create_user(user_params) do
          conn
          |> put_status(:created)
          |> render("auth.json", user: user)
        else
          {:error, changeset} ->
            conn
            |> send_resp(:bad_request, "Error creating user.")
        end
      else
        conn
        |> send_resp(:no_content, "")
      end
    end
  end


  def login(conn, %{"email" => email, "password" => password}) do
    if String.length(password) < 8 do
      conn
      |> put_status(:bad_request)
      |> render("auth_error.json", %{error: "The password must be at least 8 characters long."})
    else
      user = TimeManagerApi.Timemanager.get_user_by_email(email)

      if is_nil(user) do
        conn
        |> put_status(:bad_request)
        |> render("auth_error.json", %{error: "Invalid email or password"})
      else
        verify = TimeManagerApi.Auth.verify(user, password)

        if verify == false do
          conn
          |> put_status(:bad_request)
          |> render("auth_error.json", %{error: "Invalid email or password"})
        else
          token = TimeManagerApi.Auth.sign(user.id)
          render(conn, "token.json", %{token: token, user: user})
        end
      end
    end
  end

end
