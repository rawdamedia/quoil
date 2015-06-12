defmodule ParseResultsTest do
  use ExUnit.Case

  import Quoil.ParseResults, only: [parse_result: 1]

  @test_ping1 "PING google.com (216.58.220.110): 56 data bytes\n\n--- google.com ping statistics ---\n5 packets transmitted, 5 packets received, 0.0% packet loss\nround-trip min/avg/max/stddev = 51.321/53.851/55.948/1.647 ms\n"
  @test_ping2 "PING 8.8.4.4 (8.8.4.4): 56 data bytes\n\n--- 8.8.4.4 ping statistics ---\n7 packets transmitted, 7 packets received, 0.0% packet loss\nround-trip min/avg/max/stddev = 51.109/55.723/59.160/2.592 ms\n"
  @test_ping3 "PING google.com.au (216.58.220.99): 56 data bytes\n\n--- google.com.au ping statistics ---\n15 packets transmitted, 14 packets received, 6.7% packet loss\nround-trip min/avg/max/stddev = 48.489/50.580/55.803/2.043 ms\n"

  test "parse_results able to extract the target URL and IP address" do
    {parsed_rslt, _ , _} = parse_result({@test_ping1, %{}, ""})
    assert parsed_rslt.targetURL == "google.com"
    assert parsed_rslt.targetIP  == "216.58.220.110"
    {parsed_rslt, _ , _} = parse_result({@test_ping2, %{}, ""})
    assert parsed_rslt.targetURL == "8.8.4.4"
    assert parsed_rslt.targetIP  == "8.8.4.4"
    {parsed_rslt, _ , _} = parse_result({@test_ping3, %{}, ""})
    assert parsed_rslt.targetURL == "google.com.au"
    assert parsed_rslt.targetIP  == "216.58.220.99"
  end

  test "parse_result able to extract the packet numbers" do
    {parsed_rslt, _ , _} = parse_result({@test_ping1, %{}, ""})
    assert parsed_rslt.sent == "5"
    assert parsed_rslt.received  == "5"
    assert parsed_rslt.loss  == "0.0"
    {parsed_rslt, _ , _} = parse_result({@test_ping2, %{}, ""})
    assert parsed_rslt.sent == "7"
    assert parsed_rslt.received  == "7"
    assert parsed_rslt.loss  == "0.0"
    {parsed_rslt, _ , _} = parse_result({@test_ping3, %{}, ""})
    assert parsed_rslt.sent == "15"
    assert parsed_rslt.received  == "14"
    assert parsed_rslt.loss  == "6.7"
  end

  test "parse_result able to extract the packet round-trip statistics" do 
    {parsed_rslt, _ , _} = parse_result({@test_ping1, %{}, ""})
    assert parsed_rslt.min == "51.321"
    assert parsed_rslt.avg  == "53.851"
    assert parsed_rslt.max  == "55.948"
    assert parsed_rslt.stddev == "1.647"
    {parsed_rslt, _ , _} = parse_result({@test_ping2, %{}, ""})
    assert parsed_rslt.min == "51.109"
    assert parsed_rslt.avg  == "55.723"
    assert parsed_rslt.max  == "59.160"
    assert parsed_rslt.stddev == "2.592"
    {parsed_rslt, _ , _} = parse_result({@test_ping3, %{}, ""})
    assert parsed_rslt.min == "48.489"
    assert parsed_rslt.avg  == "50.580"
    assert parsed_rslt.max  == "55.803"
    assert parsed_rslt.stddev == "2.043"
  end

end