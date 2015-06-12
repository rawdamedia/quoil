defmodule CliTest do
  use ExUnit.Case

  import Quoil.CLI
  import Quoil.ArgsProcessor, only: [parse_args: 1]

  @tag timeout: 10000000

  # Testing run_ping function

  test "able to run ping function" do
    {test_data, _, _} = run_ping(parse_args(["-i","1","-n","3","google.com"]))
    assert String.starts_with?(test_data, "PING") && String.contains?(test_data, "google.com")
  end

end