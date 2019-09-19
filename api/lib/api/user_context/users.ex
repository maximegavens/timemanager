defmodule Api.UserContext.Users do
  use Ecto.Schema
  import Ecto.Changeset

  alias Api.WorkingtimeContext.Workingtimes
  alias Api.ClockContext.Clocks

  schema "users" do
    field :email, :string
    field :role, :string
    field :username, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :team, :integer
    has_many :workingtimes, Workingtimes
    has_many :clocks, Clocks

    timestamps()
  end

  @doc false
  def changeset(users, attrs) do
    users
    |> cast(attrs, [:role, :username, :email, :password, :team])
    |> validate_required([:role, :username, :email, :password, :team])
    |> put_password_hash()
  end

  def changeset_team(users, attrs) do
    users
    |> cast(attrs, [:team])
    |> validate_required([:team])
  end

  def promote_user(users) do
    users
    |> cast(%{"role" => "manager"}, [:role])
    |> validate_required([:role])
  end


  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
