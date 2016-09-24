defmodule PhilosophersStone.GenServer do
  defmacro __using__(_opts) do
    quote do
      use GenServer

      import PhilosophersStone.Operations
      import PhilosophersStone.Responders
    end
  end
end
