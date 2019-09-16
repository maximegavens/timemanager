defmodule Api.UserContext.Users do
  use Ecto.Schema
  import Ecto.Changeset

  alias Api.WorkingtimeContext.Workingtimes
  alias Api.ClockContext.Clocks

  schema "users" do
    field :email, :string
    field :username, :string
    has_many :workingtimes, Workingtimes
    has_many :clocks, Clocks

    timestamps()
  end

  @doc false
  def changeset(users, attrs) do
    users
    |> cast(attrs, [:username, :email])
    |> validate_required([:username, :email])
  end
end
