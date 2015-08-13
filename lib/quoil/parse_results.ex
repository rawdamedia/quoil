defmodule Quoil.ParseResults do
  @moduledoc """
  this module is only required to parse the results returned by the System `ping` utility
  """

  import Map

  def parse_result({{:error, message}, ip_pinged, switches, log_file_name}) do
    parsed_rslt = %{targetURL: ip_pinged} |> put(:result, "ERROR") |> put(:message, message)

    {parsed_rslt, ip_pinged, switches, log_file_name}
  end
  
  def parse_result({rslt, ip_pinged, switches, log_file_name}) do
    regexes = %{
      targetURL: ~r{\APING\s(.*)\s}r,
      targetIP:  ~r{\s[(](.*)[)]}r,
      sent:      ~r{\b(\d+) packets transmitted\b}r,
      received:  ~r{\b(\d+) (?:packets )?received\b}r,
      loss:      ~r{\b(\d+[.]?\d*)[%] packet loss\b}r
    }

    parsed_rslt = Enum.reduce(regexes, %{}, fn({key,val}, rslt_map) -> put(rslt_map, key, (Regex.run(val, rslt) |> List.last))  end)

    if parsed_rslt.received == "0" do
      message = Application.get_env(:quoil, :exit_codes)[2]
      parsed_rslt = put(parsed_rslt, :message, message)
    else
      # Extract stats
      regex = ~r{(\d+[.]\d+[/]\d+[.]\d+[/]\d+[.]\d+[/]\d+[.]\d+)\sms\Z}r
      [min, avg, max, stddev] = Regex.run(regex, rslt) |> List.last |> String.split("/")
      parsed_rslt = %{min: min, avg: avg, max: max, stddev: stddev} |> merge(parsed_rslt)
    end

    parsed_rslt = parsed_rslt |> put(:result, "OK")

    {parsed_rslt, ip_pinged, switches, log_file_name}
  end

end