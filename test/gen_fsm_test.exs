defmodule GenFsmTest do
  use ExUnit.Case
  import ExUnit.CaptureLog

  defmodule Sample do
    use GenFSM

    def init(args) do
      { :ok, :sample, args }
    end
  end

  test "sync event stops server on unknown requests" do
    capture_log fn->
      Process.flag(:trap_exit, true)
      assert { :ok, pid } = GenFSM.start_link(Sample, [:hello], [])

      catch_exit(:gen_fsm.sync_send_all_state_event(pid, :unknown_request))
      assert_receive {:EXIT, ^pid, :unexpected_event}
    end
  after
    Process.flag(:trap_exit, false)
  end

  test "event stops server on unknown requests" do
    capture_log fn->
      Process.flag(:trap_exit, true)
      assert { :ok, pid } = GenFSM.start_link(Sample, [:hello], [])

      :gen_fsm.send_all_state_event(pid, :unknown_request)
      assert_receive {:EXIT, ^pid, :unexpected_event}
    end
  after
    Process.flag(:trap_exit, false)
  end
end
