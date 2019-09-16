defmodule Api.ClockContext.Clocks do
  use Ecto.Schema
  import Ecto.Changeset

  alias Api.UserContext.Users

  schema "clocks" do
    field :status, :boolean, default: false
    field :time, :naive_datetime
    belongs_to :user, Users

    timestamps()
  end

  @doc false
  def changeset(clocks, attrs) do
    clocks
    |> cast(attrs, [:time, :status])
    |> validate_required([:time, :status])
  end
end
