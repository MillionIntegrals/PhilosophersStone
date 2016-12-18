defmodule PhilosophersStone.Development do
  @moduledoc """
  Example usage:

  import PhilosophersStone.Development
  import PhilosophersStone.Operations
  import PhilosophersStone.Responders

  debug_macro do
  defcall inc(), state: state do
  reply_and_set(state, state+1)
  end
  end

  debug_macro do
  defcast set(value) do
  noreply_and_set(value)
  end
  end
  """

  @doc "Print given code before and after macro expansion"
  defmacro debug_macro(do: code) do
    IO.inspect code

    code_to_insert = Macro.escape(code)

    quote do
      IO.puts "Macro String"
      IO.puts ">>>>>>>>>>>>>>>>>>>>>>"
      unquote(code_to_insert) |> Macro.to_string |> IO.puts
      IO.puts "Expanded"
      IO.puts ">>>>>>>>>>>>>>>>>>>>>>"
      unquote(code_to_insert) |> Macro.expand(__ENV__) |> Macro.to_string |> IO.puts
      IO.puts "======================"
    end
  end
end
