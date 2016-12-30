defmodule Stone.Operations do
  @moduledoc """
  Basic building blocks for your `GenServer`s.
  Use these macros to define your desired functionality.
  """

  alias Stone.Declaration

  @doc """
  Define server starting function(`start`, `start_link`) together with corresponding `init/1`.
  """
  defmacro defstart(declaration_ast, options \\ []) do
    declaration = Declaration.from_ast(declaration_ast)

    quote bind_quoted: [
      declaration: Macro.escape(declaration),
      options: Macro.escape(options, unquote: true)
    ] do
      Stone.Operations.Implementation.define_starter(declaration, options ++ @stone_settings)
      |> Stone.MacroHelpers.inject_to_module(__MODULE__, __ENV__)
    end
  end

  @doc """
  Define server `init/1` function clause with parameters packed as a tuple.
  """
  defmacro definit(arg \\ quote(do: _), options \\ []) do
    quote bind_quoted: [
      arg: Macro.escape(arg),
      options: Macro.escape(options)
    ] do
      Stone.Operations.Implementation.define_init(arg, options ++ @stone_settings)
      |> Stone.MacroHelpers.inject_to_module(__MODULE__, __ENV__)
    end
  end

  @doc """
  Define server `handle_call/3` function with parameters packed as a tuple.
  """
  defmacro defcall(declaration_ast, options \\ [], body \\ []) do
    declaration = Declaration.from_ast(declaration_ast)

    quote bind_quoted: [
      declaration: Macro.escape(declaration),
      options: Macro.escape(options, unquote: true),
      body: Macro.escape(body, unquote: true)
    ] do
      Stone.Operations.Implementation.define_handler(:defcall, declaration, __MODULE__, options ++ body ++ @stone_settings)
      |> Stone.MacroHelpers.inject_to_module(__MODULE__, __ENV__)
    end
  end

  @doc """
  Define server `handle_cast/2` function with parameters packed as a tuple.
  """
  defmacro defcast(declaration_ast, options \\ [], body \\ []) do
    declaration = Declaration.from_ast(declaration_ast)

    quote bind_quoted: [
      declaration: Macro.escape(declaration),
      options: Macro.escape(options, unquote: true),
      body: Macro.escape(body, unquote: true)
    ] do
      Stone.Operations.Implementation.define_handler(:defcast, declaration, __MODULE__, options ++ body ++ @stone_settings)
      |> Stone.MacroHelpers.inject_to_module(__MODULE__, __ENV__)
    end
  end
end
