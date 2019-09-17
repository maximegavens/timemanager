defmodule Api.UserContext.Users do
  use Ecto.Schema
  import Ecto.Changeset

  alias Api.WorkingtimeContext.Workingtimes
  alias Api.ClockContext.Clocks

  schema "users" do
    field :email, :string
    field :status, :string
    field :username, :string
    field :password, :string
    field :team, :integer
    has_many :workingtimes, Workingtimes
    has_many :clocks, Clocks

    timestamps()
  end

  @doc false
  def changeset(users, attrs) do
    users
    |> cast(attrs, [:status, :username, :email, :password, :team])
    |> validate_required([:status, :username, :email, :password, :team])
  end
end
