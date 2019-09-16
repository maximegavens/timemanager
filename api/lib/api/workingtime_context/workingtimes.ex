defmodule Api.WorkingtimeContext.Workingtimes do
  use Ecto.Schema
  import Ecto.Changeset

  alias Api.UserContext.Users

  schema "workingtimes" do
    field :end, :naive_datetime
    field :start, :naive_datetime
    belongs_to :user, Users

    timestamps()
  end

  @doc false
  def changeset(workingtimes, attrs) do
    workingtimes
    |> cast(attrs, [:start, :end])
    |> validate_required([:start, :end])
  end
end
