defmodule TodoistIntegration.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias TodoistIntegration.Repo
  alias TodoistIntegration.Guardian

  alias TodoistIntegration.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    User
    |> Repo.all()
    |> with_auth_token()
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
  def get_user!(id) do
    User
    |> Repo.get!(id)
  end

  def get_user_with_auth_token!(id) do
    User
    |> Repo.get!(id)
    |> with_auth_token()
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
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
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
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Returns a token for given user. Token works for one day.
  Currently there is no endpoint for refreshing tokens/getting new ones for
  exisitng user. In normal application that should be implemented.

  ## Examples

      iex> create_token(author)
      {:ok, "asddsadsasazxc"}

  """
  defp create_token(%User{} = user) do
    case Guardian.encode_and_sign(user, %{}, ttl: {1, :day}) do
      {:ok, token, _claims} ->
        {:ok, token}
      {_} ->
        {:error, ""}
    end
  end

  def with_auth_token(%User{} = user) do
    case create_token(user) do
      {:ok, token} -> %{user | auth_token: token}
      _ -> %{user | auth_token: nil}
    end
  end

  def with_auth_token(users) do
    users
    |> Enum.map(fn u -> with_auth_token(u) end)
  end
end
