#WORK IN PROGRESS - UNSUPPORTED BY RACKSPACE - USE AT YOUR OWN RISK
======
# raxcdb
##Rackspace Public Cloud Databases Scripts and Documentation

###migrate.sh
This is a script for migrating from one MySQL Server to Another. 
The primarey intention is to migrate to Rackspace Cloud Databases. 

This script will dump your application's databases and users. 
It can stream these to a new destination or dump locally. 

####Usage
```
MySQL Migration Helper
----------------------
This script should help migrate mysql databases,
without breaking Rackspace Specific user accounts,
and/or system specific database/tables.
----------------------
Options...

--srcuser <String> #Source Database Migration User.
--srcpass <String> #Source Database Migration Password.
--srchost <String> #Source Database Hostname/IP address.

Note: If you don't provide these details, the mysql(dump)
 commands will be run with default values (from my.cnf).

--dstuser <String> #Destination Database Username.
--dstpass <String> #Destination Database Password.
--dsthost <String> #Destination Database Hostname/IP.

--stream #Direct transfer from the source to destination.

Note: Destination is required to do full migration.
 If there is no destination configuration, only the
 MySQLDump and User Grants will be pulled down to '/tmp'.

```

