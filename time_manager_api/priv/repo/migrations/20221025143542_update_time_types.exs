defmodule TimeManagerApi.Repo.Migrations.UpdateTimeTypes do
  use Ecto.Migration

  def change do
    alter table(:clocks) do
      modify :time, :utc_datetime_usec
    end

    alter table(:workingtimes) do
      modify :start, :utc_datetime_usec
      modify :end, :utc_datetime_usec
    end
  end
end
