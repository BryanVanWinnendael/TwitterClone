defmodule TwitterCloneWeb.Plugs.ApiPlug do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> get_token()
    |> verify_token()
    |> case do
      {:ok, user_id} ->
        assign(conn, :current_user, user_id)
      _unauthorized -> assign(conn, :current_user, nil)
    end
  end

  def authenticate_api_user(conn, _opts) do
    if Map.get(conn.assigns, :current_user) do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(TwitterCloneWeb.ErrorView)
      |> render(:"401")

      |> halt()
    end
  end

  @doc """
  Generate a new token for a user id.

  ## Examples

      iex> TwitterCloneWeb.Plugs.ApiPlug.generate_token(123)
      "xxxxxxx"

  """
  def generate_token(user_id) do
    Phoenix.Token.sign(
      TwitterCloneWeb.Endpoint,
      "user auth",
      user_id
    )
  end

  @doc """
  Verify a user token.

  ## Examples

      iex> TwitterCloneWeb.Plugs.ApiPlug.verify_token("good-token")
      {:ok, 1}

      iex> TwitterCloneWeb.Plugs.ApiPlug.verify_token("bad-token")
      {:error, :invalid}

      iex> TwitterCloneWeb.Plugs.ApiPlug.verify_token("old-token")
      {:error, :expired}

      iex> TwitterCloneWeb.Plugs.ApiPlug.verify_token(nil)
      {:error, :missing}

  """
  @spec verify_token(nil | binary) :: {:error, :expired | :invalid | :missing} | {:ok, any}
  def verify_token(token) do
    one_month = 30 * 24 * 60 * 60

    Phoenix.Token.verify(
      TwitterCloneWeb.Endpoint,
      "user auth",
      token,
      max_age: one_month
    )
  end

  @spec get_token(Plug.Conn.t()) :: nil | binary
  def get_token(conn) do
    case get_req_header(conn, "api_key") do
      [token] -> token

      _ -> nil
    end
  end
end
