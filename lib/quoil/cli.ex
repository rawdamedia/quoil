defmodule Quoil.CLI do
  @moduledoc """
  Command line parsing for the quoil function  
    -> running the ping command  
    -> interpreting the results  
    -> logging
    """

  # load defaults from config.exs
  @default_interval Application.get_env(:quoil, :default_interval)
  @default_number Application.get_env(:quoil, :default_number)
  
  #require Logger

  def main(argv) do
    # Logger.configure level: :debug

    argv
    |> parse_args
    |> run_ping
    |> parse_result
    |> write_log

  end

  @doc """
  *argv* can be -h or --help, which returns :help.  
  Optional switches can be specified:  
  - *\-\-interval* or *-i* to set the interval in seconds between pings
  - *\-\-number* or *-n* to set the number of pings in each run  
  Need to specify the *ip_to_ping* as an IP address or URL.  
  If *log_file_name* is not specified, it defaults to *:std_out*  

  Return a tuple of `{ip_to_ping, %{switches}, log_file_name}`, or `:help` if help was given.
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

  def process_switches(true, _, _) do
    :help
  end

  @doc"""
  Makes sure that if --help|-h is included anywhere then all other options are ignored and help is printed.  
  Returns a data tuple of `{*ip_to_ping*, *switches*, *log_file_name*}` where:  
  - *ip_to_ping* is a String of either the URL or IP to be supplied to the `ping` command.
  - *switches* is a map containing all the values (default or supplied) for the options to be passed to the ping command.
  - *log_file_name* is **:std_out** or the path to the file to save the results to. 
  """
  def process_switches(nil, switches, [ip_to_ping | log_file_name]) do
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

  def run_ping(:help) do
    IO.puts """
    usage: quoil [-h | --help]
    quoil [--interval sec] [--number nr] <ip_to_ping> [log_file_name]
    
    For more information see: https://github.com/rawdamedia/quoil
    """
    System.halt(0)
  end

  def run_ping(:error) do
    IO.puts "ERROR: There was an error with the command line switches."
    System.halt(:abort)
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
    parsed_rslt = Map.new()
    # Extract targetURL
    regex = ~r/\APING\s(.*)\s/r
    parsed_rslt = Map.put(parsed_rslt, :targetURL, Regex.run(regex, rslt)|>List.last)

    # Extract targetIP
    regex = ~r/\s[(](.*)[)]/r
    parsed_rslt = Map.put(parsed_rslt, :targetIP, Regex.run(regex, rslt)|>List.last)

    {parsed_rslt, switches, log_file_name}
  end
  
  def write_log({parsed_rslt, switches, log_file_name}) do
    log_data = log_writer(log_file_name)

  end


  def log_writer(:std_out) do
    # Return a function that will output appropriately formatted text to the screen
    fn (data) ->
      IO.puts "PING statistics from #{get_timestamp()}"
      IO.puts "========================================\n"
      IO.puts "The target was: #{data.targetURL} (#{data.targetIP})."
    end
  end

  def log_writer(log_file_name) do
    # Return a function that will append appropriately formatted text to a file.
    # If the file doesn't exist, it needs to be created and a header row inserted first.
  end
  
  @doc"""
  Returns the current local date and time as a string in the format:
  *yyyy-MM-dd hh:mm:ss*
  """
  def get_timestamp() do
    {{yr,mo,dy}, {hr,mi,se}} = :calendar.local_time()
    "#{yr}-#{mo}-#{dy} #{hr}:#{mi}:#{se}"
  end
  

end