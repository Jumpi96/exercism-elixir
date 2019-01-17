defmodule RobotSimulator do
  @moduledoc """
  A robot capable of rotating and translating in base on a group of instructions.
  """
  defguard is_direction(value) when value in [:north, :west, :east, :south]
  defguard is_instruction(value) when value in [?R, ?L, ?A]
  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0, 0})
  def create(direction, _position) when not is_direction(direction) do
    {:error, "invalid direction"}
  end
  def create(direction, {x, y}) 
      when is_integer(x) and is_integer(y) do
    {direction, {x, y}}
  end
  def create(_direction, _position), do: {:error, "invalid position"}

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, ""), do: robot
  def simulate(_robot, << head :: utf8, _tail :: binary>>)
      when not is_instruction(head) do
    {:error, "invalid instruction"}
  end
  def simulate(robot, << head :: utf8, tail :: binary >>) do
    robot |> do_simulate(head) |> simulate(tail)
  end
  defp do_simulate({direction, position}, ?A) do
    {direction, translate(direction, position)}
  end
  defp do_simulate({direction, position}, instruction) do
    {rotate(direction, instruction), position}
  end
  defp translate(direction, {x, y}) do
    case direction do
      :north -> {x, y + 1}
      :east -> {x + 1, y}
      :south -> {x, y - 1}
      :west -> {x - 1, y}
    end
  end
  defp rotate(direction, ?R) do
    case direction do
      :north -> :east
      :east -> :south
      :south -> :west
      :west -> :north
    end
  end
  defp rotate(direction, ?L) do
    case direction do
      :north -> :west
      :west -> :south
      :south -> :east
      :east -> :north
    end
  end
  
  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction({direction, _position}), do: direction

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position({_direction, position}), do: position
end
