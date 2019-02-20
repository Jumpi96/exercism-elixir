defmodule Forth do
  defstruct stack: [], state: %{}
  @separators ["\n", "\r", "\t", " ", "\x00", "\x01"]
  @unary_operators ["DUP", "DROP"]
  @binary_operators ["/", "*", "+", "-", "SWAP", "OVER"]

  @doc """
  Create a new evaluator.
  """
  @spec new() :: Forth
  def new(), do: %Forth{}

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(Forth, String.t()) :: Forth
  def eval(ev, s) do
    {stack, state} = s 
      |> String.upcase
      |> String.split(@separators)      
      |> do_eval(nil, nil, [], ev)
    %Forth{stack: stack, state: state}
  end

  def do_eval([], first_arg, second_arg, stack, state) do
    {stack ++ [first_arg, second_arg], state}
  end
  def do_eval([head | _tail], nil, nil, _stack, _state) 
      when head in @unary_operators or head in @binary_operators do
    raise Forth.StackUnderflow
  end
  def do_eval([head | tail], nil, nil, stack, state) do 
    do_eval(tail, head, nil, stack, state)
  end
  def do_eval([eval_h | eval_t], first_arg, nil, [stack_h | stack_t], state) 
      when eval_h in @binary_operators do
    do_eval([eval_h | eval_t], stack_h, first_arg, stack_t, state)
  end
  def do_eval([head | tail], first_arg, nil, stack, state)
      when head in @unary_operators do
    case head do
      "DUP" -> do_eval(tail, first_arg, first_arg, stack, state)
      "DROP" -> do_eval(tail, nil, nil, stack, state)
    end
  end
  def do_eval([head | _tail], _first_arg, nil, _stack, _state) when head in @binary_operators do
    raise Forth.StackUnderflow
  end
  def do_eval([head | tail], first_arg, nil, stack, state) do
    do_eval(tail, first_arg, head, stack, state)
  end
  def do_eval([head | tail], first_arg, second_arg, stack, state) 
      when head in @binary_operators do
    {parsed_first, ""} = first_arg |> Integer.parse
    {parsed_second, ""} = second_arg |> Integer.parse
    case head do
      "/" -> 
        do_eval([inspect(divide(parsed_first, parsed_second))] ++ tail, nil, nil, stack, state)
      "*" -> 
        do_eval([inspect(parsed_first * parsed_second)] ++ tail, nil, nil, stack, state)
      "+" -> 
        do_eval([inspect(parsed_first + parsed_second)] ++ tail, nil, nil, stack, state)
      "-" -> 
        do_eval([inspect(parsed_first - parsed_second)] ++ tail, nil, nil, stack, state)
      "SWAP" -> 
        do_eval(tail, second_arg, first_arg, stack, state)
      "OVER" -> 
        do_eval(tail, second_arg, first_arg, stack ++ [first_arg], state)
    end
  end
  def do_eval([head | tail], first_arg, second_arg, stack, state) do 
    do_eval([head | tail], second_arg, nil, stack ++ [first_arg], state)
  end

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(Forth) :: String.t()
  def format_stack(%Forth{stack: []}), do: ""
  def format_stack(%Forth{stack: [head | tail], state: state}) do
    tail_formatted = format_stack(%Forth{stack: tail, state: state})
    case tail_formatted do
      "" -> "#{head}"
      _ -> "#{head} #{tail_formatted}"
    end
  end

  defp divide(_dividend, 0), do: raise Forth.DivisionByZero
  defp divide(dividend, divisor), do: dividend |> div(divisor)

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
