defmodule PhilosophersStone.Operations do
  alias PhilosophersStone.MacroHelpers
  alias PhilosophersStone.Arguments

  import PhilosophersStone.Operations.Implementation

  @doc """
  Define server starting function(`start`, `start_link`) together with corresponding `init/1`.
  """
  defmacro defstart(definition, opts \\ []) do
    {name, args} = Macro.decompose_call(definition)
    payload = Arguments.pack_values_as_tuple(args)

    starter_ast = define_starter(name, args, payload, opts)

    init_ast = if opts[:do] do
      do_definit(payload, opts[:do])
    end

    MacroHelpers.block_helper([starter_ast, init_ast])
  end

  @doc """
  Define server `init/1` function with parameters packed as a tuple.
  """
  defmacro definit(arg \\ quote(do: _), opts), do: do_definit(arg, opts[:do])

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
