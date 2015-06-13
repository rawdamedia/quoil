defmodule Quoil.Repeat do
  def times ({nr, rpt_interval, args}) do
    Stream.interval(rpt_interval * 60 * 1000)
    |> Stream.take(nr)
    |> Enum.map()
  end
  
end