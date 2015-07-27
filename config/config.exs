# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for third-
# party users, it should be done in your mix.exs file.

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]
help_message = """
    usage: 
    quoil [-h | --help]
    quoil [--interval sec] [--number nr] [--repeat nr [--wait min]] [--system] <ip_to_ping> [log_file_name]
    
    all values supplied must be positive integers

    For more information see: https://github.com/rawdamedia/quoil
    """

exit_codes = %{
   2 => "The transmission was successful but no responses were received.",
  64 => "The command was used incorrectly.",
  65 => "The input data was incorrect in some way.",
  66 => "An input file (not a system file) did not exist or was not readable.",
  68 => "The host specified did not exist.",
  77 => "You did not have sufficient permission to perform the operation."
}

config :quoil, 
          interval_between_pings_sec: 3,
          number_of_pings:            20,
          wait_period_min:            60,
          help_message:               help_message,
          exit_codes:                 exit_codes

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"
