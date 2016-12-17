defmodule GenServerTest do
  use ExUnit.Case


  defmodule TestServer1 do
    use PhilosophersStone.GenServer

    defstart start_link(val) do
      initial_state(val)
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

    defcast set(value) do
      noreply_and_set(value)
    end
  end


  test "starting server" do
    # import PhilosophersStone.Development
    # import PhilosophersStone.Operations
    # import PhilosophersStone.Responders

    # debug_macro do
    #   defcall inc(), state: state do
    #     reply_and_set(state, state+1)
    #   end
    # end

    # debug_macro do
    #   defcast set(value) do
    #     noreply_and_set(value)
    #   end
    # end

    {:ok, pid} = TestServer1.start_link 6

    assert TestServer1.get(pid) == 6
    assert TestServer1.inc(pid) == 6
    assert TestServer1.get(pid) == 7

    TestServer1.set(pid, 0)

    assert TestServer1.get(pid) == 0
    assert TestServer1.inc(pid) == 0
    assert TestServer1.get(pid) == 1

    assert Process.alive?(pid)
  end
end
