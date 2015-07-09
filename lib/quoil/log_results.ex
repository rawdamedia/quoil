defmodule Quoil.LogResults do
  
  def write_log({parsed_rslt, ip_pinged, switches, log_file_name}) do
    log_data = log_writer(log_file_name)
    log_data.(parsed_rslt)
    {ip_pinged, switches, log_file_name}
  end


  def log_writer(:std_out) do
    # Return a function that will output appropriately formatted text to the screen
    fn (data) ->
      IO.puts "\nPING statistics from #{get_timestamp()}"
      IO.puts "========================================"
      IO.puts "The target was: #{data.targetURL} (#{data.targetIP})."
      IO.puts "packets sent = #{data.sent} -> received = #{data.received} => #{data.loss}% lost."
      IO.puts "round-trip statistics: avg = #{data.avg}ms; stddev = #{data.stddev}ms; range = #{data.min}-#{data.max}ms\n"
    end
  end

  def log_writer(log_file_name) do
    # Return a function that will append appropriately formatted text to a file.
    # If the file doesn't exist, it needs to be created and a header row inserted first.
    fn (data) ->
      unless File.exists?(log_file_name) do
        #create the file and add the header row
        header = "\"TimeStamp\"\t\"TargetURL\"\t\"TargetIP\"\t\"Sent\"\t\"Rcvd\"\t\"Loss\"\t\"Min\"\t\"Avg\"\t\"Max\"\t\"SD\""
        File.open(log_file_name, [:append, :utf8], fn(file) ->
          IO.puts(file, header)
        end)
      end
      #write the subsequent row of data
      data_line = "\"#{get_timestamp()}\"\t\"#{data.targetURL}\"\t\"#{data.targetIP}\"\t\"#{data.sent}\"\t\"#{data.received}\"\t\"#{data.loss}\"\t\"#{data.min}\"\t\"#{data.avg}\"\t\"#{data.max}\"\t\"#{data.stddev}\""
      File.open(log_file_name, [:append, :utf8], fn(file) ->
          IO.puts(file, data_line)
      end)
    end
  end
  
  @doc"""
  Returns the current local date and time as a string in the format:
  *yyyy-MM-dd hh:mm:ss*
  """
  def get_timestamp() do
    pad = fn nr -> nr |> to_string |> String.rjust(2,?0) end
    {{yr,mo,dy}, {hr,mi,se}} = :calendar.local_time()
    "#{yr}-#{pad.(mo)}-#{pad.(dy)} #{pad.(hr)}:#{pad.(mi)}:#{pad.(se)}"
  end

end