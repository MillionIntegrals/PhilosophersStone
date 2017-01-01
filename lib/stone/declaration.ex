defmodule Stone.Declaration do
  @moduledoc """
  A structure holding information about function head declaration -- name,
  arguments, default values.
  """

  @enforce_keys [:name, :args]

  alias Stone.Declaration

  defstruct [:name, :args]

  @doc "Create a declaration struct from declaration AST"
  def from_ast(declaration) do
    {name, args} = Macro.decompose_call(declaration)
    %Declaration{name: name, args: args}
  end

  @doc """
  Take a list of function arguments and pack them into a tuple.

  ## Examples

  iex> Stone.Declaration.pack_as_tuple(quote(do: [1, 2, 3]))
  quote(do: {1, 2, 3})

  iex> Stone.Declaration.pack_as_tuple(quote(do: [x, y, z]))
  quote(do: {x, y, z})
  """
  def pack_as_tuple(values) do
    quote do
      {unquote_splicing(values)}
    end
  end

  @doc ~S"""
  Clears default parameter values from argument list.

  ## Examples

  iex> Stone.Declaration.clear_default_arguments(quote(do: [x, y \\ 2, z \\ 3]))
  quote(do: [x, y, z])
  """
  def clear_default_arguments(argument_list) do
    argument_list |> Enum.map(&clean_default_argument_single/1)
  end

  defp clean_default_argument_single({:\\, _, [var, _value]}) do
    var
  end

  defp clean_default_argument_single(other) do
    other
  end
end
