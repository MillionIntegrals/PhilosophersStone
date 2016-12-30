defmodule Stone.IntermediateGenServerTest do
  use ExUnit.Case, async: true

  defmodule TestServer1 do
    use Stone.GenServer

    defstart start_link(val \\ 0) do
      initial_state(val)
    end

    defstart start(x, y)
    defstart start_link(x, y)

    definit {x, y} do
      initial_state(x + y)
    end

    ### Should become
    # def start_link(x, options \\ []) do
    #   GenServer.start_link(__MODULE__, {x}, options)
    # end

    # def init({x}) do
    #   {:ok, x}
    # end

    defcall get(), state: state do
      reply(state)
    end

    ### Should become
    # def get(pid) do
    #   GenServer.call(pid, :get)
    # end

    # def handle_call(:get, from, state) do
    #   {:reply, state, state}
    # end

    defcall inc(), state: state do
      reply_and_set(state, state+1)
    end

    defcall add(x \\ 0), state: state do
      reply_and_set(state + x, state + x)
    end

    defcast set(value \\ 0)

    defcast set(:zero) do
      noreply_and_set(0)
    end

    defcast set(value) do
      noreply_and_set(value)
    end
  end


  test "starting server" do
    {:ok, pid} = TestServer1.start_link 6

    assert TestServer1.get(pid) == 6
    assert TestServer1.inc(pid) == 6
    assert TestServer1.get(pid) == 7

    TestServer1.set(pid, 0)

    assert TestServer1.get(pid) == 0
    assert TestServer1.inc(pid) == 0
    assert TestServer1.get(pid) == 1

    TestServer1.set(pid, :zero)

    assert TestServer1.get(pid) == 0
    assert TestServer1.inc(pid) == 0
    assert TestServer1.get(pid) == 1

    TestServer1.set(pid)

    assert TestServer1.get(pid) == 0
    assert TestServer1.inc(pid) == 0
    assert TestServer1.get(pid) == 1

    assert Process.alive?(pid)
  end

  test "constructor default arguments" do
    {:ok, pid} = TestServer1.start_link

    assert TestServer1.get(pid) == 0
    assert TestServer1.inc(pid) == 0
    assert TestServer1.get(pid) == 1

    assert Process.alive?(pid)
  end

  test "alternative constructors" do
    {:ok, pid} = TestServer1.start_link 1, 2

    assert TestServer1.get(pid) == 3
    assert TestServer1.inc(pid) == 3
    assert TestServer1.get(pid) == 4

    assert Process.alive?(pid)
  end

  test "alternative constructors 2" do
    {:ok, pid} = TestServer1.start 3, 2

    assert TestServer1.get(pid) == 5
    assert TestServer1.inc(pid) == 5
    assert TestServer1.get(pid) == 6

    assert Process.alive?(pid)
  end
end
