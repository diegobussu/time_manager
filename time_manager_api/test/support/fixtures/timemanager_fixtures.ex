defmodule TimeManagerApi.TimemanagerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManagerApi.Timemanager` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        username: "some username"
      })
      |> TimeManagerApi.Timemanager.create_user()

    user
  end

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~N[2022-10-24 08:17:00]
      })
      |> TimeManagerApi.Timemanager.create_clock()

    clock
  end

  @doc """
  Generate a workingtimes.
  """
  def workingtimes_fixture(attrs \\ %{}) do
    {:ok, workingtimes} =
      attrs
      |> Enum.into(%{
        end: ~N[2022-10-24 08:18:00],
        start: ~N[2022-10-24 08:18:00]
      })
      |> TimeManagerApi.Timemanager.create_workingtimes()

    workingtimes
  end

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> TimeManagerApi.Timemanager.create_team()

    team
  end
end
