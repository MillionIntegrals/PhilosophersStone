defmodule PhilosophersStone.GenServer do
  @moduledoc """
  This is the module to `use` in your code if you want to start using our extra functionality

  ## Example

  ```elixir
  defmodule CounterAgent do
    use PhilosophersStone.GenServer

    defstart start_link(val \\ 0) do
      initial_state(val)
    end
  end
  ```

  For more information about what you can define inside the module, please check
  `PhilosophersStone.Operations` and `PhilosophersStone.Responders`.
  """
  defmacro __using__(_opts) do
    quote do
      use GenServer

      import PhilosophersStone.Operations
      import PhilosophersStone.Responders

      Module.register_attribute __MODULE__, :ps_function_heads, accumulate: true
    end
  end
end
