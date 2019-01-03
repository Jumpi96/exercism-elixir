defmodule Bob do
  def hey(input) do
    last = String.slice(input, -1..-1)
    if Regex.run(~r/[A-z]*/, input) == [""] do
      cond do
        last == "?" -> "Sure."
        last == "" or last == " " -> "Fine. Be that way!"
        Regex.run(~r/[0-9 ]*/, input) == [""] or last == "!" -> "Whoa, chill out!"
        true -> "Whatever."
      end
    else
      cond do
        last == "?" and String.upcase(input) == input -> "Calm down, I know what I'm doing!"
        last == "?" -> "Sure."
        String.upcase(input) == input -> "Whoa, chill out!"
        true -> "Whatever."
      end
    end
  end
end
