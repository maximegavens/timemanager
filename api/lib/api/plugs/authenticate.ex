defmodule Api.Plugs.Authenticate do
  import Plug.Conn

  alias Api.UserContext

  def init(default), do: default

  def call(conn, _default) do
    case extract_token(conn) do
      {:ok, token} ->
        case UserContext.get_user_by_token(token) do
          nil ->
            unauthorized(conn)
          user ->
            verify_token(conn, user)
        end
      _ -> unauthorized(conn)
    end
  end

  defp authorized(conn, user) do
    # If you want, add new values to `conn`
    conn
    |> assign(:signed_in, true)
    |> assign(:signed_user, user)
  end

  defp unauthorized(conn) do
    conn |> send_resp(401, "Unauthorized") |> halt()
  end

  defp extract_token(conn) do
    case Plug.Conn.get_req_header(conn, "authorization") do
      [auth_header] -> {:ok, auth_header}
      _ -> {:error, :missing_auth_header}
    end
  end

  defp verify_token(conn, user) do
    if NaiveDateTime.compare(user.expiry, DateTime.utc_now) == :gt do
      authorized(conn, user)
    else
      unauthorized(conn)
    end
  end

end
