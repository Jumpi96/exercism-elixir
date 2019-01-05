defmodule Markdown do
  @moduledoc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(md_text) do
    # REFACTOR: Using pipe operator to make code more clear.
    md_text |> String.split("\n")
      |> Enum.map(fn t -> process(t) end)
      |> Enum.join
      |> patch
  end

  defp process(line) do
    first_grapheme = String.first(line)
    # REFACTOR: Using case do instead of if clauses.
    case first_grapheme do
      "#" -> line |> parse_header_md_level |> enclose_with_header_tag
      "*" -> parse_list_md_level(line)
      _ -> enclose_with_paragraph_tag(String.split(line))
    end
  end

  defp parse_header_md_level(header) do
    [head | tail] = String.split(header)
    {to_string(String.length(head)), Enum.join(tail, " ")}
  end

  defp parse_list_md_level(list) do
    items = list |> String.trim_leading("* ") |> String.split
    "<li>#{join_words_with_tags(items)}</li>"
  end

  defp enclose_with_header_tag({tag, header}) do
    # REFACTOR: Using string interpolation for clarity.
    "<h#{tag}>#{header}</h#{tag}>"
  end

  defp enclose_with_paragraph_tag(text) do
    "<p>#{join_words_with_tags(text)}</p>"
  end

  defp join_words_with_tags(text) do
    # REFACTOR: Using pipe operator to make code more clear.
    text |> Enum.map(fn w -> replace_md_with_tag(w) end)
      |> Enum.join(" ")
  end

  defp replace_md_with_tag(word) do
    # REFACTOR: Using pipe operator to make code more clear.
    word |> replace_prefix_md |> replace_suffix_md
  end

  defp replace_prefix_md(word) do
    cond do
      word =~ ~r/^#{"__"}{1}/ -> String.replace(word, ~r/^#{"__"}{1}/, "<strong>", global: false)
      word =~ ~r/^[#{"_"}{1}][^#{"_"}+]/ -> String.replace(word, ~r/_/, "<em>", global: false)
      true -> word
    end
  end

  defp replace_suffix_md(word) do
    cond do
      word =~ ~r/#{"__"}{1}$/ -> String.replace(word, ~r/#{"__"}{1}$/, "</strong>")
      word =~ ~r/[^#{"_"}{1}]/ -> String.replace(word, ~r/_/, "</em>")
      true -> word
    end
  end

  defp patch(parsed_text) do
    # REFACTOR: Using pipe operator to make code more clear.
    parsed_text |> String.replace("<li>", "<ul><li>", global: false)
      |> String.replace_suffix("</li>", "</li></ul>")
  end
end
