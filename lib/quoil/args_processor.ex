defmodule Quoil.ArgsProcessor do
  @moduledoc """
  ###Processes the command-line arguments passed to the quoil app

  *argv* can be *-h* or *--help*, which returns *:help*, ignoring any other switches that may have been specified.  

  Optional switches can be specified:  
  - *\-\-interval* or *-i* to set the interval in seconds between pings
  - *\-\-number* or *-n* to set the number of pings in each run  
  - *\-\-repeat* or *-r* to repeat an additional specified number of times (defaults to *nil*)  
  - *\-\-wait* or *-w* to set the number of minutes before repeating (ignored unless *\-\-repeat* also specified)  
  Need to specify the *ip_to_ping* as an IP address or URL.  
  If *log_file_name* is not specified, it defaults to *:std_out*  

  Return a tuple of `{ip_to_ping, %{switches}, log_file_name}`, or `:help` if help was requested or error in supplied switches.
  """

  @default_interval Application.get_env(:quoil, :interval_between_pings_sec)
  @default_number Application.get_env(:quoil, :number_of_pings)
  @default_wait Application.get_env(:quoil, :wait_period_min)


  def parse_args(argv) do
    # IO.puts argv
    parse = OptionParser.parse(argv,
      strict: [help: :boolean, interval: :integer, number: :integer, repeat: :integer, wait: :integer],
      aliases:  [h: :help, i: :interval, n: :number, r: :repeat, w: :wait])
    # Logger.info "Parsed arguments: #{Kernel.inspect(parse)}"
    case parse do
      { _, _, errors} when errors != [] -> :help
      { switches, arguments, _ } -> process_switches(switches[:help], Enum.into(switches, %{}), arguments)
      _ -> :error
    end
  end


  @doc"""
  Makes sure that if --help|-h is included anywhere then all other options are ignored and help is printed.  
  Returns a data tuple of `{*ip_to_ping*, *switches*, *log_file_name*}` where:  
  - *ip_to_ping* is a String of either the URL or IP to be supplied to the `ping` command.
  - *switches* is a map containing all the values (default or supplied) for the options to be passed to the ping command.
  - *log_file_name* is **:std_out** or the path to the file to save the results to. 
  """
  def process_switches(true, _, _) do
    :help
  end
  def process_switches(nil, %{}, []) do
    :help
  end
  def process_switches(nil, switches, [ip_to_ping | log_file_name]) do
    # in the future can implement logging to multiple destinations
    switches = Map.put_new(switches, :interval, @default_interval)
    switches = Map.put_new(switches, :number, @default_number)
    switches = Map.put_new(switches, :wait, @default_wait)

    # make sure that only positive integers are passed
    switches = Enum.reduce([:interval, :number, :repeat, :wait], switches, 
                fn (key, map) -> Map.update(map, key, nil, fn(val)->Kernel.abs(val) end) end)

    if log_file_name == [] do
      log_file_name = :std_out
    else
      log_file_name = List.first(log_file_name)
      # NB this will cause all non-switches after log_file_name to be ignored
    end
    {ip_to_ping, switches, log_file_name}
  end

end