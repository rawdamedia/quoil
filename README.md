QuOIL
=====

QuOIL checks the quality of the internet link by logging the ping statistics to a specified server at defined intervals.  The results can be saved to a file, that can then be analysed by other programs.

The usage is as follows:

`quoil [-h | --help]`

* This prints a summary of the usage.

`quoil [--interval sec] [--number nr] [--repeat nr [--wait min]] [--system] <ip_to_ping> [log_file_name]`

* *\-\-interval sec* sets the number of seconds between each ping.  If it is not specified, it defaults to *:interval_between_pings_sec* specified in [**config/config.exs**](config/config.exs) (*\-\-interval* can be shortened to *-i*).

* *\-\-number nr* sets the number of pings in each set used to generate the ping statistics.  If it is not specified, it defaults to *:number_of_pings* specified in [**config/config.exs**](config/config.exs) (*\-\-number* can be shortened to *-n*).

* *\-\-repeat nr* sets the number of times that the ping sets are to be repeated.  If it is not specified, it defaults to *nil*, which means that quoil will run only one set of pings as per the options above (*\-\-repeat* can be shortened to *-r*)

* *\-\-wait min* sets the number of minutes before repeating each set of pings (ignored unless *\-\-repeat* also specified).  If it is is not specified, it defaults to *:wait_period_min* specified in [**config/config.exs**](config/config.exs) (*\-\-wait* can also be shortened to *-w*).

* *\-\-system* causes quoil to use the system `ping` utility rather than Erlang/Elixir functionality.

* *ip_to_ping* can also be a URL that resolves to a valid IP.

* If *log_file_name* is not specified, it defaults to Standard Output.
    If *log_file_name* is specified as an absolute or relative path, and it does not exist, then it will be created as a tab-delimited log file, with the first row as headers for the subsequent data.  If the file does exist, then the data will be appended to the end.

All values supplied with optional switches should be non-negative integers.

##Using Quoil

The simplest way to use `quoil` is to [download](https://github.com/rawdamedia/quoil/blob/master/quoil?raw=true "Direct download of the precompiled `quoil` utility") the file [**quoil**](./quoil) in the same directory as this **README.md** file.  This file has been compiled by Erlang's *escript* utility from the Elixir source in this repository.

Assuming the prerequisites are met (see below), it can be launched from the command line as listed above with any desired options.

###Requirements for running `quoil` from the command line
- running a Unix-like operating system
- [Erlang](http://www.erlang.org "Erlang Homepage") is installed
- [*ping*](http://linux.die.net/man/8/ping "ping man page") system utility installed
- *quoil* file has appropriate execute permissions set
