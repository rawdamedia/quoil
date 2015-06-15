defmodule ArgsProcessorTest do
  use ExUnit.Case

  import Quoil.ArgsProcessor, only: [parse_args: 1]
  import Map

  @default_interval Application.get_env(:quoil, :interval_between_pings_sec)
  @default_number   Application.get_env(:quoil, :number_of_pings)
  @default_wait     Application.get_env(:quoil, :wait_period_min)

  @default_switches %{interval: @default_interval, number: @default_number, repeat: nil, wait: @default_wait}

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
    assert parse_args(["-ih", "anything"]) == :help
    assert parse_args(["-hi", "anything"]) == :help
    assert parse_args(["--help","--interval", "7", "anything"]) == :help
    assert parse_args(["--interval", "--help", "anything"]) == :help
    assert parse_args(["anything","--help"]) == :help
  end

  test ":help returned by an unknown option" do
    assert parse_args(["--unknown", "anything"]) == :help
  end

  test "passing ip_to_ping and log_file_name gets processed correctly" do
    assert parse_args(["ip_to_ping","log_file_name"]) == {"ip_to_ping", @default_switches , "log_file_name"}
  end

  test "allowing the interval of the pings to be specified" do
    switches = @default_switches |> put(:interval, 15)
    assert parse_args(["--interval", "15", "ip_to_ping","log_file_name"]) == {"ip_to_ping", switches , "log_file_name"}
    assert parse_args(["-i", "15", "ip_to_ping","log_file_name"]) == {"ip_to_ping", switches , "log_file_name"}
  end

  test "not specifying log_file_name prints to standard output" do
    assert parse_args(["ip_to_ping"]) == {"ip_to_ping", @default_switches, :std_out}
  end

  test "allowing the number of pings in each group to be specified" do
    switches = @default_switches |> put(:number, 25)
    assert parse_args(["-n", "25", "ip_to_ping", "log_file_name"]) == {"ip_to_ping", switches , "log_file_name"}
    assert parse_args(["--number", "25", "ip_to_ping", "log_file_name"]) == {"ip_to_ping", switches , "log_file_name"}
  end

  test "specifying both number and interval still works" do
    switches = @default_switches |> put(:interval, 23) |> put(:number, 45)
    assert parse_args(["--interval", "23", "--number", "45", "ip_to_ping", "log_file_name"]) == {"ip_to_ping", switches , "log_file_name"}
    assert parse_args(["--number", "45", "--interval", "23", "ip_to_ping", "log_file_name"]) == {"ip_to_ping", switches , "log_file_name"}
  end

  test "recognises the --repeat switch" do
    assert parse_args(["--repeat", "3", "ip_to_ping", "log_file_name"]) == {"ip_to_ping", @default_switches |> put(:repeat, 3), "log_file_name"}
  end

  test "any negative values specified for switches cause help to be printed" do
    assert parse_args(["--number", "-1", "anything"]) == :help
    assert parse_args(["--interval", "-1", "anything"]) == :help
    assert parse_args(["--repeat", "-1", "anything"]) == :help
    assert parse_args(["--wait", "-1", "anything"]) == :help
  end

end