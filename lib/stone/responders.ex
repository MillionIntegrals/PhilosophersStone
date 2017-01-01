defmodule Stone.Responders do
  @moduledoc """
  Various macros useful for returning simpler responses from
  init/call/cast/info handlers.
  """

  @doc """
  Set initial state of the actor.
  Should be used in `definit`/`defstart`.

  ## Examples
      iex> Stone.Responders.initial_state(1)
      {:ok, 1}
  """
  defmacro initial_state(state) do
    quote do
      {:ok, unquote(state)}
    end
  end

  @doc """
  Return this, when you don't care about the initial state of the actor.
  Should be used in `definit`/`defstart`.

  ## Examples
      iex> Stone.Responders.no_initial_state()
      {:ok, nil}
  """
  defmacro no_initial_state() do
    quote do
      {:ok, nil}
    end
  end

  @doc """
  Set initial state of the actor and timeout for initialization.
  Should be used in `definit`/`defstart`.
  Allows for setting a timeout.

  ## Examples
      iex> Stone.Responders.initial_state(:state, 1000)
      {:ok, :state, 1000}
  """
  defmacro initial_state(state, timeout) do
    quote do
      {:ok, unquote(state), unquote(timeout)}
    end
  end

  @doc """
  Send a reply from the generic server request handler without changing the
  state.
  """
  defmacro reply(response) do
    quote do
      {:reply, unquote(response), unquote(Stone.GenServer.state_var)}
    end
  end

  @doc """
  Send a reply from generic server request handler and change the state.

  ## Examples
      iex> Stone.Responders.reply_and_set(:ok, :state)
      {:reply, :ok, :state}
  """
  defmacro reply_and_set(response, new_state) do
    quote do
      {:reply, unquote(response), unquote(new_state)}
    end
  end

  @doc """
  Don't send a reply from the generic server request handler and don't change a state.
  """
  defmacro noreply() do
    quote do
      {:noreply, unquote(Stone.GenServer.state_var)}
    end
  end

  @doc """
  Don't send a reply from generic server request handler and set a new state.

  ## Examples
      iex> Stone.Responders.noreply_and_set(:state)
      {:noreply, :state}
  """
  defmacro noreply_and_set(new_state) do
    quote do
      {:noreply, unquote(new_state)}
    end
  end
end
