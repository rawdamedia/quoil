defmodule CliTest do
  use ExUnit.Case

  import Quoil.CLI, only: [parse_args: 1]
  @default_interval Application.get_env(:quoil, :default_interval)
  @default_number Application.get_env(:quoil, :default_number)

  defp make_switches(interval, number) do
    switches = Map.new()
    switches = Map.put(switches, :interval, interval)
    switches = Map.put(switches, :number, number)
    switches
  end

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
end