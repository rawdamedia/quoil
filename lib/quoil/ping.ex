defmodule Quoil.Ping do
  @moduledoc """
  This module pings using either the System 'ping' command,
  or the (gen_icmp)[https://github.com/msantos/gen_icmp] library (to be implemented)
  """

  import Quoil.ParseResults

  @doc """
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
    if exit_code > 2 do
      message = Application.get_env(:quoil, :exit_codes)[exit_code]
      IO.puts Quoil.LogResults.get_timestamp()
      IO.puts "ERROR: The ping command exited with code: #{exit_code}"
      IO.puts "Message: #{message}\n"
      rslt = {:error, "#{exit_code}: #{message}"}
    end
    {rslt, ip_to_ping, switches, log_file_name}
  end
  
end