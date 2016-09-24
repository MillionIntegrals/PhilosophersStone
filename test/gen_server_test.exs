defmodule GenServerTest do
  use ExUnit.Case

  defmodule TestServer do
    use PhilosophersStone.GenServer

    defstart start_link(x) do
      initial_state(x+1)
    end

    ### Should become
    # def start_link(x, options \\ []) do
    #   GenServer.start_link(__MODULE__, {x}, options)
    # end

    # def init({x}) do
    #   {:ok, x + 1}
    # end
  end


  test "starting server" do
    {:ok, pid} = TestServer.start_link 1
    assert Process.alive?(pid)
  end
end
