defmodule PingTest do
  use ExUnit.Case

  import String
  import ExUnit.CaptureIO

  @tag timeout: 10000000

  # Testing run_ping function

  test "able to run ping function" do
    test_data = capture_io(fn -> Quoil.CLI.main(["-i","1","-n","3","-s","google.com"]) end)
    IO.puts test_data
    assert (contains?(test_data, "\nPING statistics")) && (contains?(test_data, "google.com"))
  end

  # test "asking for help terminates the program" do
  #   IO.puts ""
  #   assert catch_exit(main(["--help"])) == 0
  # end

  # test "passing unknown switches terminates the program" do
  #   IO.puts ""
  #   assert catch_exit(main(["--unknown"])) == 0
  # end

  # test "terminate_early? exits the program on receiving :help" do
  #   IO.puts ""
  #   assert catch_exit(terminate_early?(:help)) == 0
  # end
end