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
    |> Quoil.Ping.run_ping
    |> Quoil.ParseResults.parse_result
    |> Quoil.LogResults.write_log
    |> Quoil.Repeat.requested?

  end


  def terminate_early?(:help) do
    IO.puts Application.get_env(:quoil, :help_message)
    System.halt(0)
  end
  def terminate_early?(:error) do
    IO.puts "ERROR: There was an error with the command line switches."
    System.halt(:abort)
  end
  def terminate_early?(switches) do
    switches
  end
  
end