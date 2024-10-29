defmodule TimeManagerApi.TimemanagerTest do
  use TimeManagerApi.DataCase

  alias TimeManagerApi.Timemanager

  describe "users" do
    alias TimeManagerApi.Timemanager.User

    import TimeManagerApi.TimemanagerFixtures

    @invalid_attrs %{email: nil, username: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Timemanager.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Timemanager.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{email: "some email", username: "some username"}

      assert {:ok, %User{} = user} = Timemanager.create_user(valid_attrs)
      assert user.email == "some email"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Timemanager.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{email: "some updated email", username: "some updated username"}

      assert {:ok, %User{} = user} = Timemanager.update_user(user, update_attrs)
      assert user.email == "some updated email"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Timemanager.update_user(user, @invalid_attrs)
      assert user == Timemanager.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Timemanager.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Timemanager.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Timemanager.change_user(user)
    end
  end

  describe "clocks" do
    alias TimeManagerApi.Timemanager.Clock

    import TimeManagerApi.TimemanagerFixtures

    @invalid_attrs %{status: nil, time: nil}

    test "list_clocks/0 returns all clocks" do
      clock = clock_fixture()
      assert Timemanager.list_clocks() == [clock]
    end

    test "get_clock!/1 returns the clock with given id" do
      clock = clock_fixture()
      assert Timemanager.get_clock!(clock.id) == clock
    end

    test "create_clock/1 with valid data creates a clock" do
      valid_attrs = %{status: true, time: ~N[2022-10-24 08:17:00]}

      assert {:ok, %Clock{} = clock} = Timemanager.create_clock(valid_attrs)
      assert clock.status == true
      assert clock.time == ~N[2022-10-24 08:17:00]
    end

    test "create_clock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Timemanager.create_clock(@invalid_attrs)
    end

    test "update_clock/2 with valid data updates the clock" do
      clock = clock_fixture()
      update_attrs = %{status: false, time: ~N[2022-10-25 08:17:00]}

      assert {:ok, %Clock{} = clock} = Timemanager.update_clock(clock, update_attrs)
      assert clock.status == false
      assert clock.time == ~N[2022-10-25 08:17:00]
    end

    test "update_clock/2 with invalid data returns error changeset" do
      clock = clock_fixture()
      assert {:error, %Ecto.Changeset{}} = Timemanager.update_clock(clock, @invalid_attrs)
      assert clock == Timemanager.get_clock!(clock.id)
    end

    test "delete_clock/1 deletes the clock" do
      clock = clock_fixture()
      assert {:ok, %Clock{}} = Timemanager.delete_clock(clock)
      assert_raise Ecto.NoResultsError, fn -> Timemanager.get_clock!(clock.id) end
    end

    test "change_clock/1 returns a clock changeset" do
      clock = clock_fixture()
      assert %Ecto.Changeset{} = Timemanager.change_clock(clock)
    end
  end

  describe "workingtimes" do
    alias TimeManagerApi.Timemanager.Workingtimes

    import TimeManagerApi.TimemanagerFixtures

    @invalid_attrs %{end: nil, start: nil}

    test "list_workingtimes/0 returns all workingtimes" do
      workingtimes = workingtimes_fixture()
      assert Timemanager.list_workingtimes() == [workingtimes]
    end

    test "get_workingtimes!/1 returns the workingtimes with given id" do
      workingtimes = workingtimes_fixture()
      assert Timemanager.get_workingtimes!(workingtimes.id) == workingtimes
    end

    test "create_workingtimes/1 with valid data creates a workingtimes" do
      valid_attrs = %{end: ~N[2022-10-24 08:18:00], start: ~N[2022-10-24 08:18:00]}

      assert {:ok, %Workingtimes{} = workingtimes} = Timemanager.create_workingtimes(valid_attrs)
      assert workingtimes.end == ~N[2022-10-24 08:18:00]
      assert workingtimes.start == ~N[2022-10-24 08:18:00]
    end

    test "create_workingtimes/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Timemanager.create_workingtimes(@invalid_attrs)
    end

    test "update_workingtimes/2 with valid data updates the workingtimes" do
      workingtimes = workingtimes_fixture()
      update_attrs = %{end: ~N[2022-10-25 08:18:00], start: ~N[2022-10-25 08:18:00]}

      assert {:ok, %Workingtimes{} = workingtimes} = Timemanager.update_workingtimes(workingtimes, update_attrs)
      assert workingtimes.end == ~N[2022-10-25 08:18:00]
      assert workingtimes.start == ~N[2022-10-25 08:18:00]
    end

    test "update_workingtimes/2 with invalid data returns error changeset" do
      workingtimes = workingtimes_fixture()
      assert {:error, %Ecto.Changeset{}} = Timemanager.update_workingtimes(workingtimes, @invalid_attrs)
      assert workingtimes == Timemanager.get_workingtimes!(workingtimes.id)
    end

    test "delete_workingtimes/1 deletes the workingtimes" do
      workingtimes = workingtimes_fixture()
      assert {:ok, %Workingtimes{}} = Timemanager.delete_workingtimes(workingtimes)
      assert_raise Ecto.NoResultsError, fn -> Timemanager.get_workingtimes!(workingtimes.id) end
    end

    test "change_workingtimes/1 returns a workingtimes changeset" do
      workingtimes = workingtimes_fixture()
      assert %Ecto.Changeset{} = Timemanager.change_workingtimes(workingtimes)
    end
  end

  describe "teams" do
    alias TimeManagerApi.Timemanager.Team

    import TimeManagerApi.TimemanagerFixtures

    @invalid_attrs %{name: nil}

    test "list_teams/0 returns all teams" do
      team = team_fixture()
      assert Timemanager.list_teams() == [team]
    end

    test "get_team!/1 returns the team with given id" do
      team = team_fixture()
      assert Timemanager.get_team!(team.id) == team
    end

    test "create_team/1 with valid data creates a team" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Team{} = team} = Timemanager.create_team(valid_attrs)
      assert team.name == "some name"
    end

    test "create_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Timemanager.create_team(@invalid_attrs)
    end

    test "update_team/2 with valid data updates the team" do
      team = team_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Team{} = team} = Timemanager.update_team(team, update_attrs)
      assert team.name == "some updated name"
    end

    test "update_team/2 with invalid data returns error changeset" do
      team = team_fixture()
      assert {:error, %Ecto.Changeset{}} = Timemanager.update_team(team, @invalid_attrs)
      assert team == Timemanager.get_team!(team.id)
    end

    test "delete_team/1 deletes the team" do
      team = team_fixture()
      assert {:ok, %Team{}} = Timemanager.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> Timemanager.get_team!(team.id) end
    end

    test "change_team/1 returns a team changeset" do
      team = team_fixture()
      assert %Ecto.Changeset{} = Timemanager.change_team(team)
    end
  end
end
