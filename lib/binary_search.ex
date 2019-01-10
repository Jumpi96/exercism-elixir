defmodule BinarySearch do
  @moduledoc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search(numbers, key) do
    do_search(numbers, key, 0..tuple_size(numbers) - 1)
  end

  defp do_search(_numbers, _key, from..to) when from > to do 
    :not_found
  end
  defp do_search(numbers, key, from..to) do
    {mid_key, index} = get_mid_key(numbers, from..to)
    cond do
      mid_key == key -> {:ok, index}
      mid_key > key -> 
        numbers |> do_search(key, from..index - 1)
      true -> 
        numbers |> do_search(key, index + 1..to)
    end
  end

  defp get_mid_key(numbers, from..to) do
    index = to |> Kernel.-(from) 
      |> Kernel./(2) |> trunc |> Kernel.+(from)
    {elem(numbers, index), index}
  end
end