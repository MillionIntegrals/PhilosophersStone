defmodule PhilosophersStone.GenServer do
  defmacro __using__(opts) do
    quote do
      use GenServer
    end
  end
end
