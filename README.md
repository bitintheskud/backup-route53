Description  
------------

This script can be run on a single host to backup all your domain hosted on Amazon Route 53.
 
Prerequisites 
-------------

 Cli53 is installed and is in your PATH. see https://github.com/barnybug/cli53 for more information on how to install cli53.
 
 If you want to run this script as a batch, create a user for this purpose with limited IAM access to route 53. 

How to use the script
---------------------

Just run it in a terminal or in a scheduler. 

How to improve
---------------

  * Compress and archive directory 
  * Add mail / notification
  * Add config file (etc)
  * Add purge for old archive 
  * Compare archive (what change)
