defmodule Api.ClockContext do
  @moduledoc """
  The ClockContext context.
  """
  import Ecto.Query, only: [from: 2]
  import Ecto.Query, warn: false
  alias Api.Repo

  alias Api.ClockContext.Clocks
  alias Api.UserContext.Users

  @doc """
  Returns the list of clocks.

  ## Examples

      iex> list_clocks()
      [%Clocks{}, ...]

  """
  def list_clocks do
    Repo.all(Clocks)
  end

  def get_clocks_by_user_id(id) do
    query = (from u in Clocks,
                where: u.user_id == ^(id),
                select: %Clocks{id: u.id, time: u.time, status: u.status, user_id: u.user_id})
    Repo.all(query)
  end

  @doc """
  Gets a single clocks.

  Raises `Ecto.NoResultsError` if the Clocks does not exist.

  ## Examples

      iex> get_clocks!(123)
      %Clocks{}

      iex> get_clocks!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clocks!(id), do: Repo.get!(Clocks, id)

  @doc """
  Creates a clocks.

  ## Examples

      iex> create_clocks(%{field: value})
      {:ok, %Clocks{}}

      iex> create_clocks(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_clocks(%Users{} = users, attrs \\ %{}) do
    %Clocks{}
    |> Clocks.changeset(attrs)
    |> Ecto.Changeset.put_change(:user_id, users.id)
    |> Repo.insert()
  end

  def get_previous_clock_by_user_id(id) do
    query = (from u in Clocks,
                  where: u.user_id == ^(id),
                  select: %Clocks{id: u.id, time: u.time, status: u.status, user_id: u.user_id},
                  order_by: [desc: u.time],
                  limit: 1)
    Repo.one(query)
  end

  @doc """
  Updates a clocks.

  ## Examples

      iex> update_clocks(clocks, %{field: new_value})
      {:ok, %Clocks{}}

      iex> update_clocks(clocks, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_clocks(%Clocks{} = clocks, attrs) do
    clocks
    |> Clocks.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Clocks.

  ## Examples

      iex> delete_clocks(clocks)
      {:ok, %Clocks{}}

      iex> delete_clocks(clocks)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clocks(%Clocks{} = clocks) do
    Repo.delete(clocks)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clocks changes.

  ## Examples

      iex> change_clocks(clocks)
      %Ecto.Changeset{source: %Clocks{}}

  """
  def change_clocks(%Clocks{} = clocks) do
    Clocks.changeset(clocks, %{})
  end
end
