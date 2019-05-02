# Tomcat-access-log-parsing
This is an awk script to parse Tomcat's access log for fun and profit

In order to enable the Tomcat access log, the following clause needs to be added to server.xml:

        <Valve className="org.apache.catalina.valves.FastCommonAccessLogValve"
                 directory="logs"  prefix="access_log." suffix=".log" 
                 fileDateFormat="yyyy-MM" pattern="common"
                                 resolveHosts="false"/>

Note that for performance reasons, in a Production environment "common" is the only safe log pattern to use and  FastCommonAccessLogValve is the only safe valve class to use on a Production environment. For more details and for mor detailed logging on non-Prodction environments please see Tomcat's valve documentation. Also note that the fileDateFormat I've specified above will produce one log file per month; modify to "yyy-MM-dd" for daily log files.

In order to turn the contents of the log into a usable .CSV file that can be opened in Excel and graphed, please copy the awk script onto the Linux server where you enabled logging, and follow the instructions within the file (it can be opened in a text editor) to run it. It uses a variety of commands only available on *nix systems and hence cannot be used on Windows servers (unless you want to install Cygwin, but that's a whole other story!).

Once you've the CSV file that that script outputs, plug its content into the Excel workbook to produce pretty graphs of the number of page hits.
