defmodule Words do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    normalize(sentence)
      |> String.split([" ", "_", ", "])
      |> count_words(%{})
  end

  def normalize(sentence) do 
    String.replace(sentence, ~r/ +/, " ")
      |> String.downcase
  end

  def count_words([], word_map), do: word_map

  def count_words([head | tail], word_map) do
    if word_map[head] != nil do
      count_words(tail, Map.put(word_map, head, word_map[head]+1))
    else
      count_words(tail, Map.put(word_map, head, 1))
    end
  end
end
