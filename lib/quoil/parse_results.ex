defmodule Quoil.ParseResults do
  
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