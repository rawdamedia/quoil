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
      { switches, arguments, _ } -> process_switches(switches[:help], Enum.into(switches, %{}), arguments)
      _ -> :error
    end
  end

  defp process_switches(true, _, _) do
    :help
  end

  defp process_switches(nil, switches, [ip_to_ping | log_file_name]) do
    # in the future can implement logging to multiple destinations
    switches = Map.put_new(switches, :interval, @default_interval)
    switches = Map.put_new(switches, :number, @default_number)
    if log_file_name == [] do
      log_file_name = :std_out
    else
      log_file_name = List.first(log_file_name)
      # NB this will ignore all non-switches after log_file_name to be ignored
    end
    {ip_to_ping, switches, log_file_name}
  end

  def process(:help) do
    IO.puts """
    usage: quoil [-h | --help]
           quoil [--interval sec] [--number nr] <ip_to_ping> [log_file_name]
    
    For more information see: https://github.com/rawdamedia/quoil
    """
    System.halt(0)
  end

  def process(:error) do
    IO.puts "ERROR: There was an error processing command line switches."
    System.halt(:abort)
  end

  def process({ip_to_ping, switches, log_file_name}) do
    
  end
  

end