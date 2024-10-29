defmodule TimeManagerApi.Timemanager.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    belongs_to :owner, TimeManagerApi.Timemanager.User
    has_many :members, TimeManagerApi.Timemanager.User
    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :owner_id])
    |> validate_required([:name, :owner_id])
    |> unique_constraint(:name)
    |> foreign_key_constraint(:owner)
  end
end
