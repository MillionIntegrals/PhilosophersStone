defmodule Stone.GenServer do
  @moduledoc """
  This is the module to `use` in your code if you want to start using functionality that allows you to
  code GenServers quicker.

  ## Example

  ```elixir
  defmodule CounterAgent do
    use Stone.GenServer

    defstart start_link(val \\ 0) do
      initial_state(val)
    end
  end
  ```

  For more information about what you can define inside the module, please check
  `Stone.Operations` and `Stone.Responders`.
  """
  defmacro __using__(opts \\ []) do
    quote bind_quoted: [
      singleton: Keyword.get(opts, :singleton)
    ] do
      use GenServer

      import Stone.Operations
      import Stone.Responders

      Module.register_attribute __MODULE__, :stone_function_heads, accumulate: true

      @stone_settings [
        singleton: singleton
      ]
    end
  end
end
