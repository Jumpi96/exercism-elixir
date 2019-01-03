defmodule Roman do
  @doc """
  Convert the number to a roman number.
  """
  @spec numerals(pos_integer) :: String.t()
  def numerals(number) do
    to_charlist(number) |> to_roman |> to_string
  end

  defp to_roman([]), do: ''
  defp to_roman(number) do
    [head | tail] = number
    <<head>> |> Integer.parse |> elem(0)
      |> Kernel.*(:math.pow(10, length(number)-1))
      |> trunc |> roman_symbol
      |> Kernel.++(to_roman(tail))
  end

  defp roman_symbol(0), do: ''
  defp roman_symbol(number) when number >= 1000 do
    case number do
      1000 -> 'M'
      2000 -> 'MM'
      3000 -> 'MMM'
    end
  end
  defp roman_symbol(number) when number >= 100 do
    case number do
      100 -> 'C'
      200 -> 'CC'
      300 -> 'CCC'
      400 -> 'CD'
      500 -> 'D'
      600 -> 'DC'
      700 -> 'DCC'
      800 -> 'DCC'
      900 -> 'CM'
    end
  end
  defp roman_symbol(number) when number >= 10 do
    case number do
      10 -> 'X'
      20 -> 'XX'
      30 -> 'XXX'
      40 -> 'XL'
      50 -> 'L'
      60 -> 'LX'
      70 -> 'LXX'
      80 -> 'LXXX'
      90 -> 'XC'
    end
  end
  defp roman_symbol(number) do
    case number do
      1 -> 'I'
      2 -> 'II'
      3 -> 'III'
      4 -> 'IV'
      5 -> 'V'
      6 -> 'VI'
      7 -> 'VII'
      8 -> 'VIII'
      9 -> 'IX'
    end
  end
  
end
