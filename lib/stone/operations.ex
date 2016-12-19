defmodule Stone.Operations do
  @moduledoc """
  Basic building blocks for your `GenServer`s.
  Use these macros to define your desired functionality.
  """

  import Stone.Operations.Implementation

  @doc """
  Define server starting function(`start`, `start_link`) together with corresponding `init/1`.
  """
  defmacro defstart(definition, opts \\ []) do
    define_starter(definition, opts)
  end

  @doc """
  Define server `init/1` function clause with parameters packed as a tuple.
  """
  defmacro definit(arg \\ quote(do: _), opts \\ []) do
    define_init(arg, opts[:do])
  end

  @doc """
  Define server `handle_call/3` function with parameters packed as a tuple.
  """
  defmacro defcall(definition, options \\ [], body \\ []) do
    define_handler(:defcall, definition, options ++ body)
  end

  @doc """
  Define server `handle_cast/2` function with parameters packed as a tuple.
  """
  defmacro defcast(definition, options \\ [], body \\ []) do
    define_handler(:defcast, definition, options ++ body)
  end
end
