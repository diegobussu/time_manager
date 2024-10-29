defmodule TimeManagerApi.Timemanager do
  @moduledoc """
  The Timemanager context.
  """

  import Ecto.Query, warn: false
  alias TimeManagerApi.Repo

  alias TimeManagerApi.Timemanager.User
  alias TimeManagerApi.Timemanager.Team

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id) do
    user = Repo.get(User, id)
    Repo.preload(user, :team)
  end

  @doc """
  Gets a single user by username and email.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user_by_att!(john, john@cena.com)
      %User{}

      iex> get_user_by_att!(john, john@cena.com)
      ** (Ecto.NoResultsError)

  """
  def get_user_by_att!(username, email), do: Repo.get_by!(User, username: username, email: email)

  def get_user_by_email(email), do: Repo.get_by(User, email: email)

  def find_user_by_email(email) do
    match = email <> "%"
    Repo.all(from u in User, where: ilike(u.email, ^match))
  end

  def find_user_by_names(firstname, lastname) do
    matchFirst = firstname <> "%"
    matchLast = lastname <> "%"
    Repo.all(from u in User, where: ilike(u.firstname, ^matchFirst), where: ilike(u.lastname, ^matchLast))
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    hashedPassword = TimeManagerApi.Auth.hash_password(attrs["password"])
    attrs = Map.put(attrs, "password", hashedPassword)
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def change_rank(%User{} = user, rank) do
    user
    |> User.changeset(Map.put(%{}, "rank", rank))
    |> Repo.update()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  alias TimeManagerApi.Timemanager.Clock

  @doc """
  Returns the list of clocks.

  ## Examples

      iex> list_clocks()
      [%Clock{}, ...]

  """
  def list_clocks do
    Repo.all(Clock)
  end

  @doc """
  Gets a single clock.

  Raises `Ecto.NoResultsError` if the Clock does not exist.

  ## Examples

      iex> get_clock!(123)
      %Clock{}

      iex> get_clock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clock!(id), do: Repo.get!(Clock, id)


  def get_clock_user_id(id) do
    Repo.one(from c in Clock, where: c.user == ^id)
  end

  @doc """
  Creates a clock.

  ## Examples

      iex> create_clock(%{field: value})
      {:ok, %Clock{}}

      iex> create_clock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
#  def create_clock(attrs) do
#    %Clock{}
#    |> Clock.changeset(attrs)
#    |> Repo.insert()
#  end

  def create_clock(user_id) do
    attrs = Map.put(%{}, "user", user_id)
    attrs = Map.put(attrs, "time", DateTime.utc_now())
    attrs = Map.put(attrs, "status", true)
    if get_clock_user_id(user_id) == nil do
      %Clock{}
      |> Clock.changeset(attrs)
      |> Repo.insert()
    else
      clock = get_clock_user_id(user_id)
      create_workingtime_from_clock(user_id)
      attrs = %{time: DateTime.utc_now, status: !clock.status}
      update_clock(clock, attrs)
    end
  end

  def create_workingtime_from_clock(user_id) do
    IO.inspect "Creating WORKING TIMES !"
    clock = get_clock_user_id(user_id)
    if clock.status do
      attrs = %{user_id: user_id, start: clock.time, end: DateTime.utc_now()}
      create_workingtimes(attrs)
    end
  end

  @doc """
  Updates a clock.

  ## Examples

      iex> update_clock(clock, %{field: new_value})
      {:ok, %Clock{}}

      iex> update_clock(clock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_clock(%Clock{} = clock, attrs) do
    clock
    |> Clock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a clock.

  ## Examples

      iex> delete_clock(clock)
      {:ok, %Clock{}}

      iex> delete_clock(clock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clock(%Clock{} = clock) do
    Repo.delete(clock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clock changes.

  ## Examples

      iex> change_clock(clock)
      %Ecto.Changeset{data: %Clock{}}

  """
  def change_clock(%Clock{} = clock, attrs \\ %{}) do
    Clock.changeset(clock, attrs)
  end

  alias TimeManagerApi.Timemanager.Workingtimes

  # WORKINGTIMES

  def get_workingtimes(user_id, id) do
    Repo.one(from w in Workingtimes, where: w.user_id == ^user_id and w.id == ^id, preload: :user)
  end

  def get_workingtimes(user_id) do
    Repo.all(from w in Workingtimes, where: w.user_id == ^user_id, preload: :user)
  end

  def get_workingtimes_by_id(id) do
    Repo.one(from w in Workingtimes, where: w.id == ^id, preload: :user)
  end

  def filter_workingtimes(user_id, start_time, end_time) do
    if start_time == nil and end_time == nil do
      get_workingtimes(user_id)
    else
      if start_time == nil do
        Repo.all(from w in Workingtimes, where: w.user_id == ^user_id and w.start <= ^end_time)
      else
        if end_time == nil do
          Repo.all(from w in Workingtimes, where: w.user_id == ^user_id and w.start >= ^start_time)
        else
          Repo.all(from w in Workingtimes, where: w.user_id == ^user_id and w.start >= ^start_time and w.start <= ^end_time)
        end
      end
    end
  end

  def create_workingtimes(attrs) do
    %Workingtimes{}
    |> Workingtimes.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, workingtimes} ->
        {:ok, Repo.preload(workingtimes, :user)}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def update_workingtimes(%Workingtimes{} = workingtimes, attrs) do
    workingtimes
    |> Workingtimes.changeset(attrs)
    |> Repo.update()
  end

  def delete_workingtimes(%Workingtimes{} = workingtimes) do
    Repo.delete(workingtimes)
  end

  def get_team_workingtimes(%Team{} = team) do
    values = Enum.map(team.members, fn x -> x.id end)
    Repo.all(from w in Workingtimes, where: w.user_id in ^values, preload: :user)
  end

  def get_team_workingtimes(%Team{} = team, %{:start_time => start_time, :end_time => end_time}) do
    values = Enum.map(team.members, fn x -> x.id end)
    Repo.all(from w in Workingtimes, where: w.user_id in ^values, where: w.start >= ^start_time and w.start <= ^end_time, preload: :user)
  end

  def get_team_workingtimes(%Team{} = team, %{:start_time => start_time}) do
    values = Enum.map(team.members, fn x -> x.id end)
    Repo.all(from w in Workingtimes, where: w.user_id in ^values, where: w.start >= ^start_time, preload: :user)
  end

  def get_team_workingtimes(%Team{} = team, %{:end_time => end_time}) do
    values = Enum.map(team.members, fn x -> x.id end)
    Repo.all(from w in Workingtimes, where: w.user_id in ^values, where: w.start <= ^end_time, preload: :user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workingtimes changes.

  ## Examples

      iex> change_workingtimes(workingtimes)
      %Ecto.Changeset{data: %Workingtimes{}}

  """
  def change_workingtimes(%Workingtimes{} = workingtimes, attrs \\ %{}) do
    Workingtimes.changeset(workingtimes, attrs)
  end

  alias TimeManagerApi.Timemanager.Team

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams do
    teams = Repo.all(Team)
    teams = Repo.preload(teams, :members)
    teams = Repo.preload(teams, :owner)
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id), do: Repo.get!(Team, id)

  def get_team(id) do
    team = Repo.get(Team, id)
    team = Repo.preload(team, :members)
    Repo.preload(team, :owner)
  end

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  def get_manager_teams(manager_id) do
    abc = Repo.all(from t in Team, where: t.owner_id == ^manager_id, preload: :members)
    Repo.preload(abc, :owner)
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{data: %Team{}}

  """
  def change_team(%Team{} = team, attrs \\ %{}) do
    team = Team.changeset(team, attrs)
    Repo.preload(team, :owner)
  end

  @doc """
    Checks if a user is the owner of a specific team.

    ## Examples

        iex> is_team_owner?(1, %Team{id: 123, owner_id: 1})
        true

        iex> is_team_owner?(2, %Team{id: 123, owner_id: 1})
        false

  """
  def is_team_owner?(user_id, %Team{owner_id: owner_id}) do
    user_id == owner_id
  end

  @doc """
  Checks if a user is a member of a specific team.

  ## Examples

      iex> is_team_member?(1, %Team{id: 123, members: [%User{id: 1}, %User{id: 2}]})
      true

      iex> is_team_member?(3, %Team{id: 123, members: [%User{id: 1}, %User{id: 2}]})
      false

  """
  def is_team_member?(user_id, %Team{members: members}) do
    Enum.any?(members, fn member -> member.id == user_id end)
  end
end
