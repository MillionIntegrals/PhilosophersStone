defmodule SimpleGenServerTest do
  use ExUnit.Case

  defmodule CounterAgent do
    use PhilosophersStone.GenServer

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

  test "simple server test" do
    {:ok, pid} = CounterAgent.start_link 6

    assert CounterAgent.get(pid) == 6
    assert CounterAgent.inc(pid) == 6
    assert CounterAgent.get(pid) == 7

    CounterAgent.set(pid, 0)

    assert CounterAgent.get(pid) == 0
    assert CounterAgent.inc(pid) == 0
    assert CounterAgent.get(pid) == 1

    assert Process.alive?(pid)
  end
end
