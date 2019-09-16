defmodule Api.WorkingtimeContext do
  @moduledoc """
  The WorkingtimeContext context.
  """

  import Ecto.Query, only: [from: 2]
  import Ecto.Query, warn: false
  alias Api.Repo
  alias Api.WorkingtimeContext.Workingtimes
  alias Api.UserContext.Users

  def list_workingtimes do
    Workingtimes
    |> Repo.all()
    |> Repo.preload(:user)
  end

  def get_workingtimes!(id) do
    Workingtimes
    |> Repo.get!(id)
  end

  def get_workingtimes_by_user_id(userID) do
    query = (from u in Workingtimes,
                  where: u.user_id == ^(userID),
                  select: %Workingtimes{id: u.id, start: u.start, end: u.end, user_id: u.user_id})
    Repo.all(query)
  end

  def get_workingtimes_by_user_id_and_start(userID, start) do
    query = (from u in Workingtimes,
                  where: u.user_id == ^(userID),
                  where: u.start == ^(start),
                  select: %Workingtimes{id: u.id, start: u.start, end: u.end, user_id: u.user_id})
    Repo.all(query)
  end

  def get_workingtimes_by_user_id_and_end(userID, endd) do
    query = (from u in Workingtimes,
                  where: u.user_id == ^(userID),
                  where: u.end == ^(endd),
                  select: %Workingtimes{id: u.id, start: u.start, end: u.end, user_id: u.user_id})
    Repo.all(query)
  end

  def get_workingtimes_by_user_id_and_start_and_end(userID, start, endd) do
    query = (from u in Workingtimes,
                  where: u.user_id == ^(userID),
                  where: u.start == ^(start),
                  where: u.end == ^(endd),
                  select: %Workingtimes{id: u.id, start: u.start, end: u.end, user_id: u.user_id})
    Repo.all(query)
  end

  def get_workingtimes_by_user_id_and_workingtime_id(userID, workingtimesID) do
    query = (from u in Workingtimes,
            where: u.id == ^(workingtimesID),
            where: u.user_id == ^(userID),
            select: %Workingtimes{id: u.id, start: u.start, end: u.end, user_id: u.user_id})
    Repo.one(query)
  end


  def create_workingtimes(%Users{} = users, attrs \\ %{}) do
    %Workingtimes{}
    |> Workingtimes.changeset(attrs)
    |> Ecto.Changeset.put_change(:user_id, users.id)
    |> Repo.insert()
  end


  def update_workingtimes(%Workingtimes{} = workingtimes, attrs) do
    workingtimes
    |> Workingtimes.changeset(attrs)
    |> Repo.update()
  end


  def delete_workingtimes(%Workingtimes{} = workingtimes) do
    Repo.delete(workingtimes)
  end


  def change_workingtimes(%Workingtimes{} = workingtimes) do
    Workingtimes.changeset(workingtimes, %{})
  end
end
