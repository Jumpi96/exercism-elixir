defmodule BinTree do
  import Inspect.Algebra

  @moduledoc """
  A node in a binary tree.

  `value` is the value of a node.
  `left` is the left subtree (nil if no subtree).
  `right` is the right subtree (nil if no subtree).
  """
  @type t :: %BinTree{value: any, left: BinTree.t() | nil, right: BinTree.t() | nil}
  defstruct value: nil, left: nil, right: nil

  # A custom inspect instance purely for the tests, this makes error messages
  # much more readable.
  #
  # BT[value: 3, left: BT[value: 5, right: BT[value: 6]]] becomes (3:(5::(6::)):)
  def inspect(%BinTree{value: v, left: l, right: r}, opts) do
    concat([
      "(",
      to_doc(v, opts),
      ":",
      if(l, do: to_doc(l, opts), else: ""),
      ":",
      if(r, do: to_doc(r, opts), else: ""),
      ")"
    ])
  end
end

defmodule Zipper do
  defstruct node: nil, trail: []
  @moduledoc """
  A zipper is a technique of representing an aggregate data 
  structure so that it is convenient for writing 
  """

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BT.t()) :: Z.t()
  def from_tree(bt) do
    %Zipper{node: bt, trail: []}
  end

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Z.t()) :: BT.t()
  def to_tree(%Zipper{node: node, trail: []}), do: node
  def to_tree(z), do: z |> up |> to_tree

  @doc """
  Get the value of the focus node.
  """
  @spec value(Z.t()) :: any
  def value(z), do: z.node.value

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Z.t()) :: Z.t() | nil
  def left(%Zipper{node: %BinTree{left: nil}}), do: nil
  def left(z) do
    %Zipper{
      node: z.node.left, 
      trail: [{:left, z.node.value, z.node.right} | z.trail]
    }
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Z.t()) :: Z.t() | nil
  def right(%Zipper{node: %BinTree{right: nil}}), do: nil
  def right(z) do
    %Zipper{
      node: z.node.right, 
      trail: [{:right, z.node.value, z.node.left} | z.trail]
    }
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Z.t()) :: Z.t()
  def up(%Zipper{trail: []}), do: nil
  def up(%Zipper{node: node, trail: [{:right, value, branch} | trail]}) do
    %Zipper{
      node: %BinTree{
        value: value,
        left: branch,
        right: node
      },
      trail: trail
    }
  end
  def up(%Zipper{node: node, trail: [{:left, value, branch} | trail]}) do
    %Zipper{
      node: %BinTree{
        value: value,
        left: node,
        right: branch
      },
      trail: trail
    }
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Z.t(), any) :: Z.t()
  def set_value(z, v) do
    %{z | node: %{z.node | value: v}}
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Z.t(), BT.t()) :: Z.t()
  def set_left(z, l) do
    %{z | node: %{z.node | left: l}}
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Z.t(), BT.t()) :: Z.t()
  def set_right(z, r) do
    %{z | node: %{z.node | right: r}}
  end
end
