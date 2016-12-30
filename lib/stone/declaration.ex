defmodule Stone.Declaration do
  @moduledoc """
  A structure holding information about function head declaration -- name, arguments, default values.
  """

  @enforce_keys [:name, :args]

  alias Stone.Declaration

  defstruct [:name, :args]

  @doc "Create a declaration struct from declaration AST"
  def from_ast(declaration) do
    {name, args} = Macro.decompose_call(declaration)
    %Declaration{name: name, args: args}
  end
end
