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

  defmacro reply(response) do
    quote do
      {:reply, unquote(response), unquote(PhilosophersStone.MacroHelpers.state_var)}
    end
  end

  defmacro reply_and_set(response, new_state) do
    quote do
      {:reply, unquote(response), unquote(new_state)}
    end
  end

  defmacro noreply() do
    quote do
      {:noreply, unquote(PhilosophersStone.MacroHelpers.state_var)}
    end
  end

  defmacro noreply_and_set(new_state) do
    quote do
      {:noreply, unquote(new_state)}
    end
  end
end
