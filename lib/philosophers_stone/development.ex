defmodule PhilosophersStone.Development do
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
