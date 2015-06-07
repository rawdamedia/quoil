defmodule Quoil.CLI do
  @moduledoc """
  Command line parsing for the quoil function
  """

  @default_interval Application.get_env(:quoil, :default_interval)
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
      strict: [help: :boolean, interval: :integer],
      aliases:  [h: :help, i: :interval])
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

  defp process_switches(nil, switches, [ip_to_ping, log_file_name]) do
    case switches[:interval] do
      nil -> {ip_to_ping, @default_interval, log_file_name}
      interval -> {ip_to_ping, interval, log_file_name}
    end
  end

  def process(:help) do
    IO.puts """
    usage: quoil [h | help]
           issues [i | interval] <ip_to_ping> <log_file_name>
           if interval is not specified, it defaults to #{@default_interval}
    """
    System.halt(0)
  end

  def process(_) do
    
  end
  

end