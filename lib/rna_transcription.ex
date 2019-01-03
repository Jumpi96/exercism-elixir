defmodule RNATranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RNATranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna([]), do: []

  def to_rna([head | tail]) do
    case head do
      ?A -> [?U | to_rna(tail)]
      ?C -> [?G | to_rna(tail)]
      ?T -> [?A | to_rna(tail)]
      ?G -> [?C | to_rna(tail)]
    end
  end

end
