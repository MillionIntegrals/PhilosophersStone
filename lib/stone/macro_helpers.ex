defmodule Stone.MacroHelpers do
  @moduledoc false

  @doc """
  Block helper - create a block from a list of statements.

  Don't make a block if there is only one statement.
  """
  def block_helper(ast)

  def block_helper(list) when is_list(list) do
    list
    |> Enum.filter(&(&1 != nil))
    |> block_helper_inner
  end

  defp block_helper_inner([]) do
    nil
  end

  defp block_helper_inner([x]) do
    x
  end

  defp block_helper_inner(list) when is_list(list) do
    {:__block__, [], list}
  end

  @doc """
  Evaluate supplied code in the context of given module.
  """
  def inject_to_module(quoted, module, env) do
    Module.eval_quoted(
      module, quoted,
      [],
      aliases: env.aliases,
      requires: env.requires,
      functions: env.functions,
      macros: env.macros,
      file: env.file,
      line: env.line
    )
  end
end
