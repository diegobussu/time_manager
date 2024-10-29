defmodule TimeManagerApi.Timemanager.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :firstname, :string
    field :lastname, :string
    field :password, :string
    belongs_to :team, TimeManagerApi.Timemanager.Team
    field :rank, Ecto.Enum, values: [:employee, :manager, :general_manager], default: :employee
    has_many :ownedTeam, TimeManagerApi.Timemanager.Team
    has_many :workingTimes, TimeManagerApi.Timemanager.Workingtimes
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :rank, :firstname, :lastname, :team_id])
    |> validate_required([:email, :password, :firstname, :lastname])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/\w+@\w+\.\w+/)
  end
end
