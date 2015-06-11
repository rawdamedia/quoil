QuOIL
=====

QuOIL checks the quality of the internet link by logging the ping statistics to a specified server at defined intervals.  The results are saved to a file, that can then be analysed by other programs.

The usage is as follows:

`quoil [-h | --help]`

* This prints a summary of the usage.

`quoil [--interval sec] [--number nr] <ip_to_ping> [log_file_name]`

* If *\-\-interval* is not specified, it defaults to *:default_interval* specified in **config.exs** (*\-\-interval* can be shortened to *-i*)  

* If *\-\-number* is not specified, it defaults to *:default_number* specified in **config.exs** (*\-\-number* can be shortened to *-n*)  

* *ip_to_ping* can also be a URL that resolves to a valid IP

* If *log_file_name* is not specified, it defaults to Standard Output.
    If *log_file_name* is specified as an absolute or relative path, and it does not exist, then it will be created as a tab-delimited log file.

