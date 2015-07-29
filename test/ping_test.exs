defmodule PingTest do
  use ExUnit.Case

  import String
  import ExUnit.CaptureIO

  # Testing run_ping function using system ping utility

  test "able to run system ping function" do
    test_data = capture_io(fn -> Quoil.CLI.main(["-i","1","-n","3","-s","google.com"]) end)
    IO.puts test_data
    assert (contains?(test_data, "\nPING statistics")) && (contains?(test_data, "google.com"))
  end

  # Testing gen_icmp

  test "able to use gen_icmp" do 
    IO.puts "--==<< Testing gen_icmp >>==--"
    {:ok, socket} = :gen_icmp.open()
    IO.puts inspect(socket)
    response = :gen_icmp.ping(socket,['www.google.com.au', 'telstra.com.au'],[])
    IO.puts inspect(response)
    assert true
  end

end