defmodule CliTest do
  use ExUnit.Case

  import Quoil.CLI, only: [parse_args: 1]

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
    assert parse_args(["ip_to_ping","log_file_name"]) == {"ip_to_ping", 5 , "log_file_name"}
  end

  test "allowing the interval of the pings to be specified" do
    assert parse_args(["--interval", "15", "ip_to_ping","log_file_name"]) == {"ip_to_ping", 15 , "log_file_name"}
    assert parse_args(["-i", "15", "ip_to_ping","log_file_name"]) == {"ip_to_ping", 15 , "log_file_name"}
  end
end