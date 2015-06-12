defmodule LogResultsTest do
  use ExUnit.Case

  import Quoil.LogResults, only: [write_log: 1]
  import Quoil.ParseResults, only: [parse_result: 1]
  import Quoil.CLI

  @test_ping1 "PING google.com (216.58.220.110): 56 data bytes\n\n--- google.com ping statistics ---\n5 packets transmitted, 5 packets received, 0.0% packet loss\nround-trip min/avg/max/stddev = 51.321/53.851/55.948/1.647 ms\n"

  test "write_log to console" do
    assert write_log(parse_result({@test_ping1, %{}, :std_out})) == :ok
  end

end