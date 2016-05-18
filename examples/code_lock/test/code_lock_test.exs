defmodule CodeLockTest do
  use ExUnit.Case

  test "punch in those numbers and await the timeout" do
    {:ok, pid} = CodeLock.start_link([1,2,3,4])

    CodeLock.button(pid, 1)
    :timer.sleep 10
    CodeLock.button(pid, 2)
    :timer.sleep 10
    CodeLock.button(pid, 3)
    :timer.sleep 10
    CodeLock.button(pid, 4)
    # we should be open by now

    # wait for the timer...
    :timer.sleep 1100

    IO.puts "done!"
  end
end
