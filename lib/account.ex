defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """
  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank do
    Agent.start_link(fn -> %{open: true, balance: 0} end, name: __MODULE__)
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(_account) do
    Agent.update(__MODULE__, &(%{open: false, balance: &1[:balance]}))
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(_account) do
    if open?() do
      Agent.get(__MODULE__, &(&1[:balance]))
    else
      {:error, :account_closed}
    end
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(_account, amount) do
    if open?() do
      Agent.update(__MODULE__, &(%{open: true, balance: &1[:balance] + amount}))
    else
      {:error, :account_closed}
    end
  end

  @doc """
  Helper to get the status of the account.
  """
  def open?(), do: Agent.get(__MODULE__, &(&1[:open]))
end
