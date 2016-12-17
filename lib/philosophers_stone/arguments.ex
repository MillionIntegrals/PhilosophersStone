defmodule PhilosophersStone.Arguments do
  @moduledoc """
  Provides macro utilities used to manipulate argument list
  """

  @doc """
  Pack a list of argument values into a tuple.
  """
  def pack_values_as_tuple([x]) do
    quote do
      unquote(x)
    end
  end

  def pack_values_as_tuple(values) do
    quote do
      {unquote_splicing(values)}
    end
  end
end
