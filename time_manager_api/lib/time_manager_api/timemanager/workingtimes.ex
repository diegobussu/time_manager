defmodule TimeManagerApi.Timemanager.Workingtimes do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtimes" do
    field :end, :utc_datetime_usec
    field :start, :utc_datetime_usec
    belongs_to :user, TimeManagerApi.Timemanager.User

    timestamps()
  end

  @doc false
  def changeset(workingtimes, attrs) do
    IO.puts "-----changeset-----"
    IO.inspect attrs
    workingtimes
    |> cast(attrs, [:start, :end, :user_id])
    |> validate_required([:start, :end, :user_id])
    |> foreign_key_constraint(:user)
  end
end
