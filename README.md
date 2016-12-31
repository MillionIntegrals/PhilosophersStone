# Stone

[![Build Status](https://travis-ci.org/MillionIntegrals/stone.svg?branch=master)](https://travis-ci.org/MillionIntegrals/stone)
[![Build Status](https://img.shields.io/hexpm/v/stone.svg)](https://hex.pm/packages/stone)


I have started this project while learning elixir macros by
trying to replicate functionality from
[sasa1977/exactor](https://github.com/sasa1977/exactor).
The source code wasn't very clear to me, so I went on and tried to reimplement
myself the same features,
while at the same time trying to maintain code simpliciy and clarity.

This project tries to reduce boilerplate when writing Elixir `GenServer`s by making use of
language metaprogramming capabilities.

Online documentation can be found [here](https://hexdocs.pm/stone/).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `stone` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:stone, "~> 0.2.0"}]
    end
    ```

  2. Ensure `stone` is started before your application:

    ```elixir
    def application do
      [applications: [:stone]]
    end
    ```

## Functionality

This project helps remove boilerplate common when implementing `GenServer` behaviour in Elixir. In particular, it can be useful in following situations:

* `start` function just packs all arguments into a tuple which it forwards to `init/1` via `GenServer.start`
* Calls and casts interface functions just forward all arguments to the server process via `GenServer.call` and `GenServer.cast`.

For other cases, you may need to use plain `GenServer` functions (which can be used together with `Stone` macros).
`Stone` is not meant to fully replace `GenServer`. It just tries to reduce boilerplate in most common cases.

## Usage Examples

Let's take a look at the following server definition:

```elixir
defmodule CounterAgent do
  use Stone.GenServer

  defstart start_link(val \\ 0) do
    initial_state(val)
  end

  defcall get(), state: state do
    reply(state)
  end

  defcall inc(), state: state do
    reply_and_set(state, state+1)
  end

  defcall add(x), state: state do
    reply_and_set(state + x, state + x)
  end

  defcast set(value) do
    noreply_and_set(value)
  end
end
```

Above code defines a simple `GenServer` that maintains a counter, and exposes a convenient
interface to be used by other processes. Without using a library, this code would look like
that:

```elixir
defmodule CounterAgent do
  use GenServer
  
  def start_link(val \\ 0, opts \\ []) do
    GenServer.start_link(CounterAgent, {val}, opts)
  end
  
  def init({val}) do
    {:ok, val}
  end
  
  def get(pid) do
    GenServer.call(pid, {:get})
  end
  
  def handle_call({:get}, _from, state) do
    {:reply, state, state}
  end
  
  def inc(pid) do
    GenServer.call(pid, {:inc})
  end
  
  def handle_call({:inc}, _from, state) do
    {:reply, state, state+1}
  end
  
  def set(pid, value \\ 0) do
    GenServer.cast(pid, {:set, value})
  end
  
  def handle_cast({:set, value}, _from, _state) do
    {:noreply, value}
  end
end
```
