# This awk program is designed for use against Tomcat's access log when configured to log the 'common' format
# It outputs (comma-separated):
# - the name of the web module (URLs_app[timedurl])
# - the date of the request (word 1 of timedurl split at spaces)
# - the hour of the request (word 2 of timedurl split at spaces)
# - the URL of the request stripped of its parameter string (word 3 of timedurl split at spaces)
# - the count of number of accesses to the URL during that hour
#
# Usage example :  cat /impact/webapplications/imp01/logs/access_log.2013-05-30.log |awk -f url_counter_datetime.awk > 2013-05-30.csv
#
# Its output can be further filtered if a particular URL is of interest, for example the landing page after
# login, by grepping for that page name in the results:
#
# e.g. cat access_log.2013-05-29.log |awk -f url_counter_datetime.awk |grep <name of interesting page> |sort > 2013-05-29.csv

{

   url_called = $7;

   if (index(url_called, ".do") > 0 || index(url_called, ".dwr") > 0) {

     # Find date/hour
       timestamp_date = substr($4, 2, 11);
       timestamp_hour = substr($4, 14, 2);       

     # Store number of calls
       pos_questionmark = index(url_called, "?");
       if (pos_questionmark > 0) {
           url_called = substr(url_called, 1, pos_questionmark - 1);
       }    
       
       timedurl = sprintf("%s %s %s", timestamp_date, timestamp_hour, url_called);
       
       URLs[timedurl] = URLs[timedurl]  + 1; 

     # Store total size returned as response
       n = split($0, words, " ");
       if (words[n - 1] == 200) {
          URLs_size[timedurl] = URLs_size[timedurl] + words[n]; 
       }   
       
     # Store application associated
       n = split(url_called, words , "/");
       URLs_app[timedurl] = words[2];
  }
}

END {
     # Print CSV column headings
     print "Web Application, Date, Hour, URL, Access count"
	 
	 # Print CSV rows
     for (timedurl in URLs) {
       n = split(timedurl, words, " ");       
       result = sprintf("%s,%s,%s:00,%s,%s", URLs_app[timedurl], words[1], words[2], words[3], URLs[timedurl]);
       print result     
     }

}

