defmodule Stone.GenServer do
  @moduledoc ~S"""
  This is the module to `use` in your code if you want to start using
  functionality that allows you to code GenServers quicker.

  ## Example

  ```elixir
  defmodule CounterAgent do
    use Stone.GenServer

    defstart start_link(val \\ 0) do
      initial_state(val)
    end
  end
  ```

  ## Options

  * `:singleton` - set it to an atom you want to register your server under
  using `:name`. It changes definition of interface functions, so that they do
  not accept `pid` argument anymore. Instead they use the name the server was
  registered under.

  For more information about macros you can use inside the server definition,
  please check `Stone.Operations` and `Stone.Responders`.
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

  # A special variable that is used to supply state in 'smart responders'
  @doc false
  def state_var do
    Macro.var(:state_var, Stone.GenServer)
  end
end
