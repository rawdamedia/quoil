defmodule Quoil.Repeat do
  def requested? ({ip_pinged, switches, log_file_name}) do
    {nr,switches} = Map.pop(switches, :repeat, nil)
    if nr != nil && nr > 0 do
      repeat_pings({nr, switches[:wait], {ip_pinged, switches, log_file_name}})
    end
  end
  

  def repeat_pings({nr, rpt_interval, args}) do
    Stream.interval(rpt_interval * 60 * 1000)
    |> Stream.take(nr)
    |> Enum.map(fn _ -> Quoil.Ping.run_ping(args)|>Quoil.ParseResults.parse_result|>Quoil.LogResults.write_log end)
  end
end