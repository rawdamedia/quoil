defmodule Quoil.CLI do
  @moduledoc """
  Command line interface for the quoil function  
    -> parsing the arguments
    -> running the ping command  
    -> interpreting the results  
    -> logging
    """

  # import Quoil.ArgsProcessor, only: [parse_args: 1]
  import Quoil.LogResults, only: [write_log: 1]

  #require Logger

  def main(argv) do
    # Logger.configure level: :debug

    argv
    |> Quoil.ArgsProcessor.parse_args
    |> terminate_early?
    |> run_ping
    |> parse_result
    |> write_log

  end


  def terminate_early?(:help) do
    IO.puts """
    usage: quoil [-h | --help]
    quoil [--interval sec] [--number nr] <ip_to_ping> [log_file_name]
    
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
    {rslt, switches, log_file_name}
  end
  
  def parse_result({rslt, switches, log_file_name}) do
    regexes = %{
      targetURL: ~r{\APING\s(.*)\s}r,
      targetIP:  ~r{\s[(](.*)[)]}r,
      sent:      ~r{\b(\d+) packets transmitted\b}r,
      received:  ~r{\b(\d+) packets received\b}r,
      loss:      ~r{\b(\d+[.]\d+)[%] packet loss\b}r
    }

    parsed_rslt = Enum.reduce(regexes, %{}, fn({key,val}, rslt_map) -> Map.put(rslt_map, key, (Regex.run(val, rslt) |> List.last))  end)

    # Extract stats
    regex = ~r{(\d+[.]\d+[/]\d+[.]\d+[/]\d+[.]\d+[/]\d+[.]\d+)\sms\Z}r
    [min, avg, max, stddev] = Regex.run(regex, rslt) |> List.last |> String.split("/")
    parsed_rslt = %{min: min, avg: avg, max: max, stddev: stddev} |> Map.merge(parsed_rslt)

    {parsed_rslt, switches, log_file_name}
  end
  
end