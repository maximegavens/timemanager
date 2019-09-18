defmodule Api.UserContext do
  @moduledoc """
  The UserContext context.
  """

  import Ecto.Query, only: [from: 2]
  import Ecto.Query, warn: false
  alias Api.Repo

  alias Api.UserContext.Users

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%Users{}, ...]

  """

  def list_users do
    Repo.all(Users)
  end

  def get_user_by_email_and_password(email, password) do
    query = (from u in Users,
          where: u.email == ^(email),
          where: u.password == ^(password),
          select: %Users{id: u.id, role: u.role, email: u.email, username: u.username, password_hash: u.password_hash, team: u.team, token: u.token, expiry: u.expiry})
    Repo.one(query)
  end

  def get_user_by_email(email) do
    query = (from u in Users,
                  where: u.email == ^(email),
                  select: %Users{id: u.id, role: u.role, email: u.email, username: u.username, password_hash: u.password_hash, team: u.team, token: u.token, expiry: u.expiry})
    Repo.one(query)
  end

  def get_users_by_team(team) do
    IO.inspect(team)
    query = (from u in Users,
                  where: u.team == ^(team),
                  select: %Users{id: u.id, role: u.role, email: u.email, username: u.username, password_hash: u.password_hash, team: u.team, token: u.token, expiry: u.expiry})
    Repo.all(query)
  end

  def get_user_by_token(token) do
    query = (from u in Users,
                  where: u.token == ^(token),
                  select: %Users{id: u.id, role: u.role, email: u.email, username: u.username, password_hash: u.password_hash, team: u.team, token: u.token, expiry: u.expiry})
    Repo.one(query)
  end

  @doc """
  Gets a single users.

  Raises `Ecto.NoResultsError` if the Users does not exist.

  ## Examples

      iex> get_users!(123)
      %Users{}

      iex> get_users!(456)
      ** (Ecto.NoResultsError)

  """
  def get_users!(id), do: Repo.get!(Users, id)

  def get_users(id) do
    Users
    |> Repo.get(id)
  end

  @doc """
  Creates a users.

  ## Examples

      iex> create_users(%{field: value})
      {:ok, %Users{}}

      iex> create_users(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_users(attrs \\ %{}) do
    %Users{}
    |> Users.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a users.

  ## Examples

      iex> update_users(users, %{field: new_value})
      {:ok, %Users{}}

      iex> update_users(users, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_users(%Users{} = users, attrs) do
    users
    |> Users.changeset(attrs)
    |> Repo.update()
  end

  def update_token(%Users{} = users, attrs) do
    users
    |> Users.changeset_token(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Users.

  ## Examples

      iex> delete_users(users)
      {:ok, %Users{}}

      iex> delete_users(users)
      {:error, %Ecto.Changeset{}}

  """
  def delete_users(%Users{} = users) do
    Repo.delete(users)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking users changes.

  ## Examples

      iex> change_users(users)
      %Ecto.Changeset{source: %Users{}}

  """
  def change_users(%Users{} = users) do
    Users.changeset(users, %{})
  end
end
