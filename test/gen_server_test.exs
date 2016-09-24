defmodule GenServerTest do
  use ExUnit.Case

  defmodule TestServer do
    use PhilosophersStone.GenServer

    defstart start_link(x) do
      initial_state(x)
    end

    ### Should become
    # def start_link([x], options \\ []) do
    #   GenServer.start_link(__MODULE__, [x], options)
    # end

    # def init([x]) do
    #   {:ok, x}
    # end
  end


  test "starting server" do
    import PhilosophersStone.Operations

    quoted = quote do
      defstart start_link(x) do
        initial_state(x)
      end
    end

    q2 = quote do
      definit({x}) do
        initial_state(x)
      end
    end

    quoted
    |> Macro.expand(__ENV__)
    |> Macro.expand(__ENV__)
    |> Macro.expand(__ENV__)
    |> Macro.to_string
    |> IO.puts

    q2
    |> Macro.expand(__ENV__)
    |> Macro.expand(__ENV__)
    |> Macro.expand(__ENV__)
    |> Macro.to_string
    |> IO.puts

    {:ok, pid} = TestServer.start_link 1

    assert Process.alive?(pid)
  end
end
