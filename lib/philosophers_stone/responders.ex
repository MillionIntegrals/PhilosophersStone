defmodule PhilosophersStone.Responders do
  @doc """
  Set initial state of the actor.
  Should be used in `definit`/`defstart`.
  """
  defmacro initial_state(state) do
    quote do
      {:ok, unquote(state)}
    end
  end


  @doc """
  Set initial state of the actor and timeout for initialization.
  Should be used in `definit`/`defstart`.
  """
  defmacro initial_state(state, timeout) do
    quote do
      {:ok, unquote(state), unquote(timeout)}
    end
  end
end
