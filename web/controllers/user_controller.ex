defmodule SummitChat.UserController do
  use SummitChat.Web, :controller
  plug :authenticate_user when action in [:show]

  alias SummitChat.User

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> SummitChat.Auth.login(user)
        |> put_flash(:info, "Sign up successful!")
        |> redirect(to: chat_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render conn, "show.html", user: user
  end
end
