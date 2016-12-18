defmodule PhilosophersStone.GenServer do
  defmacro __using__(_opts) do
    quote do
      use GenServer

      import PhilosophersStone.Operations
      import PhilosophersStone.Responders

      Module.register_attribute __MODULE__, :ps_function_heads, accumulate: true
    end
  end
end
