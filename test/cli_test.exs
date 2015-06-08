defmodule CliTest do
  use ExUnit.Case

  import Quoil.CLI

  @tag timeout: 10000000

  @default_interval Application.get_env(:quoil, :default_interval)
  @default_number Application.get_env(:quoil, :default_number)
  @test_ping1 "PING google.com (216.58.220.110): 56 data bytes\n\n--- google.com ping statistics ---\n5 packets transmitted, 5 packets received, 0.0% packet loss\nround-trip min/avg/max/stddev = 51.321/53.851/55.948/1.647 ms\n"
  @test_ping2 "PING 8.8.4.4 (8.8.4.4): 56 data bytes\n\n--- 8.8.4.4 ping statistics ---\n7 packets transmitted, 7 packets received, 0.0% packet loss\nround-trip min/avg/max/stddev = 51.109/55.723/59.160/2.592 ms\n"
  @test_ping3 "PING google.com.au (216.58.220.99): 56 data bytes\n\n--- google.com.au ping statistics ---\n15 packets transmitted, 14 packets received, 6.7% packet loss\nround-trip min/avg/max/stddev = 48.489/50.580/55.803/2.043 ms\n"

  defp make_switches(interval, number) do
    switches = Map.new()
    switches = Map.put(switches, :interval, interval)
    switches = Map.put(switches, :number, number)
    switches
  end

  # Testing parse_args function

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
    assert parse_args(["-ih", "anything"]) == :help
    assert parse_args(["-hi", "anything"]) == :help
    assert parse_args(["--help","--interval", "7", "anything"]) == :help
    assert parse_args(["--interval", "--help", "anything"]) == :help
  end

  test ":help returned by an unknown option" do
    assert parse_args(["--unknown", "anything"]) == :help
  end

  test "passing ip_to_ping and log_file_name gets processed correctly" do
    assert parse_args(["ip_to_ping","log_file_name"]) == \
    {"ip_to_ping", make_switches(@default_interval, @default_number) , "log_file_name"}
  end

  test "allowing the interval of the pings to be specified" do
    assert parse_args(["--interval", "15", "ip_to_ping","log_file_name"]) == {"ip_to_ping", make_switches(15, @default_number) , "log_file_name"}
    assert parse_args(["-i", "15", "ip_to_ping","log_file_name"]) == {"ip_to_ping", make_switches(15, @default_number) , "log_file_name"}
  end

  test "not specifying log_file_name prints to standard output" do
    assert parse_args(["ip_to_ping"]) == {"ip_to_ping", make_switches(@default_interval, @default_number), :std_out}
  end

  test "allowing the number of pings in each group to be specified" do
    assert parse_args(["-n", "25", "ip_to_ping", "log_file_name"]) === {"ip_to_ping", make_switches(@default_interval, 25) , "log_file_name"}
    assert parse_args(["--number", "25", "ip_to_ping", "log_file_name"]) === {"ip_to_ping", make_switches(@default_interval, 25) , "log_file_name"}
  end

  test "specifying both number and interval still works" do
    assert parse_args(["--interval", "23", "--number", "45", "ip_to_ping", "log_file_name"]) === {"ip_to_ping", make_switches(23, 45) , "log_file_name"}
    assert parse_args(["--number", "45", "--interval", "23", "ip_to_ping", "log_file_name"]) === {"ip_to_ping", make_switches(23, 45) , "log_file_name"}
  end

  # Testing run_ping function

  test "able to run ping function" do
    {test_data, _, _} = run_ping(parse_args(["-i","1","-n","3","google.com"]))
    assert String.starts_with?(test_data, "PING") && String.contains?(test_data, "google.com")
  end

  # test parse_results

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

  test "write_log to console" do
    assert write_log(parse_result({@test_ping1, %{}, :std_out})) == :ok
  end
end