defmodule RespondersTest do
  use ExUnit.Case

  import PhilosophersStone.Responders

  test "initial_state" do
    assert initial_state(1) == {:ok, 1}
    assert initial_state(1, :hibernate) == {:ok, 1, :hibernate}
  end
end
