defmodule Quoil.CLI do
  @moduledoc """
  Command line interface for the quoil function  
    -> parsing the arguments
    -> running the ping command  
    -> interpreting the results  
    -> logging
    """

  def main(argv) do
    argv
    |> Quoil.ArgsProcessor.parse_args
    |> terminate_early?
    |> run_ping
    |> Quoil.ParseResults.parse_result
    |> Quoil.LogResults.write_log

  end


  def terminate_early?(:help) do
    IO.puts """
    usage: quoil [-h | --help]
    quoil [--interval sec] [--number nr] [--repeat nr [--wait min]] <ip_to_ping> [log_file_name]
    
    all values supplied must be positive integers

    For more information see: https://github.com/rawdamedia/quoil
    """
    System.halt(0)
  end
  def terminate_early?(:error) do
    IO.puts "ERROR: There was an error with the command line switches."
    System.halt(:abort)
  end
  def terminate_early?(switches) do
    switches
  end
  

  @doc"""
  Runs the System `ping` command.  
  Uses *ip_to_ping* and *switches* to appropriately format the `ping` command-line options.  
  Returns a tuple `{result, switches, log_file_name}` where:
  - *result* is the raw result of running the `ping` command.
  - *switches* is the unmodified map containing all the switches.
  - *log_file_name* is passed along unmodified.
  """
  def run_ping({ip_to_ping, switches, log_file_name}) do
    args = ["-q", "-c", to_string(switches[:number]), "-W", to_string(switches[:interval]), ip_to_ping]
    {rslt, exit_code} = System.cmd("ping", args)
    if exit_code != 0 do
      IO.puts "ERROR: The ping command exited with code: #{exit_code}"
      IO.puts rslt
      System.halt(:abort)
    end
    {rslt, ip_to_ping, switches, log_file_name}
  end
  
end