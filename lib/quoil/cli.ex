defmodule Quoil.CLI do
  @moduledoc """
  Command line parsing for the quoil function
  """

  # load defaults from config.exs
  @default_interval Application.get_env(:quoil, :default_interval)
  @default_number Application.get_env(:quoil, :default_number)
  
  #require Logger

  def main(argv) do
    # Logger.configure level: :debug

    argv
    |> parse_args
    |> process
  end
 
  @doc """
  `argv` can be -h or --help, which returns :help.
  An optional polling interval (in minutes) can be specified
  Return a tuple of `{ip_to_ping, interval, log_file_name}`, or `:help` if help was given.
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv,
      strict: [help: :boolean, interval: :integer, number: :integer],
      aliases:  [h: :help, i: :interval, n: :number])
    # Logger.info "Parsed arguments: #{Kernel.inspect(parse)}"
    case parse do
      { _, _, [errors]} when errors != nil -> :help
      { switches, arguments, _ } -> process_switches(switches[:help], switches, arguments)
      _ -> :error
    end
  end

  defp process_switches(true, _, _) do
    :help
  end

  defp process_switches(nil, switches, [ip_to_ping | log_file_name]) do
    # in the future can implement logging to multiple destinations
    case switches[:interval] do
      nil -> rslt = {ip_to_ping, @default_interval, List.first(log_file_name)}
      interval -> rslt = {ip_to_ping, interval, List.first(log_file_name)}
    end
    case rslt do
      {ip_to_ping, interval, nil} -> {ip_to_ping, interval, :std_out}
      _ -> rslt
    end
  end

  def process(:help) do
    IO.puts """
    usage: quoil [h | help]
           quoil [--interval min] [--number nr] <ip_to_ping> [log_file_name]
      if --interval is not specified, it defaults to #{@default_interval}
         --interval can be shortened to -i
      if --number is not specified, it defaults to #{@default_number}
         --number can be shortened to -n
      if log_file_name is not specified, it defaults to Standard Output
    """
    System.halt(0)
  end

  def process(:error) do
    IO.puts "ERROR: There was an error processing command line switches."
    System.halt(-1)
  end

  def process({ip_to_ping, interval, log_file_name}) do
    
  end
  

end