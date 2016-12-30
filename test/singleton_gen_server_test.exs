defmodule Stone.SingletonGenServerTest do
  use ExUnit.Case, async: true

  defmodule TestSingleton do
    use Stone.GenServer, singleton: __MODULE__

    defstart start_link() do
      no_initial_state()
    end

    defcall five() do
      reply(5)
    end
  end

  test "Is singleton working" do
    {:ok, pid} = TestSingleton.start_link
    assert Process.alive?(pid)

    assert TestSingleton.five() == 5
  end
end
