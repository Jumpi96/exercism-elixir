defmodule ListOps do
  @moduledoc """
  Typical List operations developed without List Elixir module.
  """

  @spec count(list) :: non_neg_integer
  def count([]), do: 0
  def count([_head | tail]) do
    count(tail) + 1
  end

  @spec reverse(list) :: list
  def reverse(list), do: do_reverse(list, [])

  defp do_reverse([], reversed), do: reversed
  defp do_reverse([head | tail], reversed) do
    do_reverse(tail, [head | reversed])
  end

  @spec map(list, (any -> any)) :: list
  def map([], _f), do: []
  def map([head | tail], f) do
    [f.(head) | map(tail, f)]
  end

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter([], _f), do: []
  def filter([head | tail], f) do
    if f.(head), do: [head | filter(tail, f)], else: filter(tail, f)
  end

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce([], acc, _f), do: acc
  def reduce([head | tail], acc, f) do
    reduce(tail, f.(head, acc), f)
  end

  @spec append(list, list) :: list
  def append(a, b), do: reduce(reverse(a), b, &do_append/2)
  defp do_append(a, b), do: [a | b]

  @spec concat([[any]]) :: [any]
  def concat([]), do: []
  def concat([head | tail]) do
    append(head, concat(tail))
  end
end
