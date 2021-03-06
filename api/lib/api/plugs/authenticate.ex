defmodule Api.Plugs.Authenticate do

  alias Api.RestrictService

  def init(default), do: default

  def call(conn, _default) do
    case RestrictService.extract_token(conn) do
      {:ok, token} ->
        case Api.Token.verify_and_validate(token) do
          {:ok, claims} ->
            case RestrictService.verify_token(claims) do
              {:ok} -> RestrictService.authorized(conn, token)
              {:error} -> RestrictService.unauthorized(conn)
            end
          {:error, _default} -> RestrictService.unauthorized(conn)
        end
      _ -> RestrictService.unauthorized(conn)
    end
  end
end
