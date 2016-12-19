defmodule Stone.Arguments do
  @moduledoc """
  Processing argument lists in Elixir macros.
  """

  @doc """
  Take a list of function arguments and pack them into a tuple.

  ## Examples

      iex> Stone.Arguments.pack_values_as_tuple(quote(do: [1, 2, 3]))
      quote(do: {1, 2, 3})

      iex> Stone.Arguments.pack_values_as_tuple(quote(do: [x, y, z]))
      quote(do: {x, y, z})
  """
  def pack_values_as_tuple(values) do
    quote do
      {unquote_splicing(values)}
    end
  end

  @doc ~S"""
  Clears default parameter values from argument list.

  ## Examples

      iex> Stone.Arguments.clear_default_arguments(quote(do: [x, y \\ 2, z \\ 3]))
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
