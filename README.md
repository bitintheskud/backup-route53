Description  
===========

    This script can be run on a single host to backup all your domain hosted on Amazon Route 53.
 
Prerequisites 
-------------

    * cli53 is installed and is in your PATH. see [https://github.com/barnybug/cli53]
    * If you want to run this script as a batch, create a user for this purpose
      with limited IAM access to route 53. 

How to improve
--------------

    * compress and archive directory 
    * add config file (etc)
    * add purge for old archive 
    * compare archive (what change)
