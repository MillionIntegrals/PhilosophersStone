defmodule PhilosophersStone.Arguments do
  @moduledoc """
  Provides macro utilities used to manipulate argument list
  """

  @doc """
  Pack a list of argument values into a tuple.
  """
  def pack_values_as_tuple(values) do
    quote do
      {unquote_splicing(values)}
    end
  end

  @doc """
  Clears default arguments from argument list.
  (a \\ 1, b \\ 2) becomes (a, b)
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
