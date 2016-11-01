#Getting Started with Cloud Databases API with CDBClient (Formerly Trove)
Written by Christopher Barnum

September 2016
##Introduction
The Rackspace Control Panel manages to give quite a bit of control and information to a customer.
However, there are many beautiful functions only accessible through the API. Although you can use CUrl against the API, an easier approach is to setup the python client CDBClient.

#####What is CDBClient?

CDBClient is a Python Client written to interact with the Rackspace Cloud Databases API. All the actions from the control panel and more are accessible through a command line. Access like this also helps power users better manage their assets.

**Note: CDBClient replaces the Trove client.**

#####Why aren't all Features in a nice GUI like the control panel already? Two reasons.

**Features so new they aren't in the control panel.**
When new features get released in the API, such as when Configuration Groups are setup for HA groups, it might not be in the Control Panel right away for customers.

**Features that are meant for advanced users.**
Some features to the product, such as enabling the root user for a cloud database instance, can cause problems in the wrong hand. Remember, you should never hesitate to reach out to Rackspace Customer Support for help with questions comments and concerns.

Always remember that the point of Cloud Databases is to bring a Database as a Service (DBaaS) that is easy to setup, configure, and use, while the product maintains itself.

##Requirements
Python 2.7+ ( https://wiki.python.org/moin/BeginnersGuide/Download )
PIP ( https://pip.pypa.io/en/stable/installing/ )

##Installation

Use PIP to install cdbclient

	pip install cdbclient

If you'd like more details on the package you're installing, you can goto https://pypi.python.org/pypi/cdbclient

##Configuration
Configuration requires knowledge of three things and one command.
1. Account Primary Username - This is the primary username used to login to mycloud.rackspace.com
2. Account/Tenant ID # - Click on your username in the upper right hand corner of the control panel.
3. Account API Key - ( https://support.rackspace.com/how-to/view-and-reset-your-api-key/ )

Run the following command.

	cdb-setup

This will automatically populate the configuration for the command "supernova" which is what feeds data to the API client. To test the configuration you can run;

	supernova cdb-iad flavor-list

And output should look something like this:

	(cdbclient) customer@cloudserver:~$ supernova cdb-iad flavor-list
	[SUPERNOVA] Running cdb-cli against cdb-iad...
	+----+----------------+-------+
	| ID | Name           |   RAM |
	+----+----------------+-------+
	|  1 | 512MB Instance |   512 |
	|  2 | 1GB Instance   |  1024 |
	|  3 | 2GB Instance   |  2048 |
	|  4 | 4GB Instance   |  4096 |
	|  5 | 8GB Instance   |  8192 |
	|  6 | 16GB Instance  | 16384 |
	|  7 | 32GB Instance  | 32768 |
	|  8 | 64GB Instance  | 65536 |
	+----+----------------+-------+



##Usage

Commands are constructed in the following manner.

	supernova <environemnt> <command>

The command cdb-setup configured environments for the different datacenters.  The default configurations include cdb-dfw, cdb-iad, cdb-lon, and cdb-ord. As you can imagine, the environment cdb-dfw will run API commands against your account in the Dallas-Fort-Worth(DFW) Datacenter, but if you chose the environment cdb-lon, your commands would be run for the API in London (If applicable to your account).

####Example Usage
Let's say we want to list our instances in our Virginia datacenter (IAD). We can use the following command;

	 supernova cdb-iad list

And you'll get a listing of Cloud Database instances like so.

	(cdbclient) customer@cloudserver:~$ supernova cdb-iad list
	[SUPERNOVA] Running cdb-cli against cdb-iad...
	+----------------------------------+---------------------------+-----------+-------------------+--------+-----------+------+
	| ID                               | Name                      | Datastore | Datastore Version | Status | Flavor ID | Size |
	+----------------------------------+---------------------------+-----------+-------------------+--------+-----------+------+
	| AAAAAAA-BBB-CCCC-EEEE-DDD-FFFFFF | SuperAwesomeCloudDataBase | mysql     | 5.6               | ACTIVE | 4         |   50 |
	+----------------------------------+---------------------------+-----------+-------------------+--------+-----------+------+


####What else can I do?

Now that you've configured cdbclient and understand command construction, let's see what we can do. Just typing `cdb-client` will show a list of commands that the client can run. If you're unsure how to use a command you can use `cdb-client help <command>` to get more information on what the command takes for arguments.

####Commands as of this writing.

	(cdbclient) customer@cloudserver:~$ cdb-cli
	usage: cdb-cli <subcommand> ...
		       [--version] [--debug] [--insecure] [--json]
		       [--bypass-url <bypass-url>] [--retries <retries>]
		       [--os-auth-system <auth-system>]
		       [--os-username <auth-username>] [--os-password <auth-password>]
		       [--os-tenant-id <tenant-id>] [--os-auth-token OS_AUTH_TOKEN]
		       [--os-auth-url OS_AUTH_URL] [--os-cacert OS_CACERT]
		       [--os-region-name <region-name>]
		       [--endpoint-type <endpoint-type>]
		       [--service-type <service-type>] [--service-name <service-name>]

	Command-line interface to the Rackspace Cloud Databases API.

	Positional arguments:
	  <subcommand>
	    bash-completion                        Prints arguments for
		                                   bash_completion.
	    help                                   Displays help about this program or
		                                   one of its subcommands.
	    backup-copy                            Copy a backup to a remote
		                                   datacenter.
	    backup-create                          Creates a backup of an instance/HA
		                                   instance.
	    backup-delete                          Deletes a backup.
	    backup-list                            Lists available backups.
	    backup-list-instance                   Lists available backups for an
		                                   instance.
	    backup-show                            Shows details of a backup.
	    configuration-parameter-create         Create datastore configuration
		                                   parameter
	    configuration-parameter-delete         Modify datastore configuration
		                                   parameter
	    configuration-parameter-list           Lists available parameters for a
		                                   configuration group.
	    configuration-parameter-modify         Modify datastore configuration
		                                   parameter
	    configuration-parameter-show           Shows details of a configuration
		                                   parameter.
	    configuration-create                   Creates a configuration group.
	    configuration-default                  Shows the default configuration of
		                                   an instance.
	    configuration-default-dsversion-flavor
		                                   Shows the default configuration for
		                                   a datastore version flavor.
	    configuration-delete                   Deletes a configuration group.
	    configuration-instances                Lists all instances associated with
		                                   a configuration group.
	    configuration-list                     Lists all configuration groups.
	    configuration-patch                    Patches a configuration group.
	    configuration-show                     Shows details of a configuration
		                                   group.
	    configuration-update                   Updates a configuration group.
	    database-create                        Creates a database on an instance.
	    database-delete                        Deletes a database from an
		                                   instance.
	    database-list                          Lists available databases on an
		                                   instance.
	    datastore-version-list                 Lists available versions for a
		                                   datastore.
	    datastore-version-show                 Shows details of a datastore
		                                   version.
	    datastore-list                         Lists available datastores.
	    datastore-show                         Shows details of a datastore.
	    flavor-list                            Lists available flavors.
	    flavor-show                            Shows details of a flavor.
	    ha-mysql-add-replica                   Adds a replica node to an existing
		                                   HA-MySQL setup.
	    ha-mysql-backup-list                   List the available backups of a HA-
		                                   MySQL Instance.
	    ha-mysql-configuration-attach          Attaches a configuration group to a
		                                   HA instance
	    ha-mysql-configuration-detach          Detaches a configuration group from
		                                   a HA instance
	    ha-mysql-create                        Creates an HA MySQL instance.
	    ha-mysql-delete                        Delete a HA MySQL Instance.
	    ha-mysql-list                          List all the HA MySQL Instances.
	    ha-mysql-remove-replica                Removes a replica node from an
		                                   existing HA-MySQL setup.
	    ha-mysql-resize-flavor                 Resize flavor across the HA cluster
	    ha-mysql-resize-volumes                Resize volumes across the HA
		                                   cluster
	    ha-mysql-restart                       Restarts a HA instance
	    ha-mysql-show                          Show details of a single HA MySQL
		                                   Instance.
	    ha-redis-create                        Creates an HA group.
	    ha-redis-delete                        Delete an HA group.
	    ha-redis-list                          List all the HA groups.
	    ha-redis-show                          Show details of an HA group.
	    configuration-attach                   Attaches a configuration group to
		                                   an instance.
	    configuration-detach                   Detaches a configuration group from
		                                   an instance.
	    convert-to-ha                          Converts the instance into HA
		                                   instance
	    create                                 Creates a new instance.
	    delete                                 Deletes an instance.
	    detach-replica                         Detaches a replica instance from
		                                   its replication source.
	    list                                   Lists all the instances.
	    replica-list                           Lists all replicas of the instance.
	    resize-flavor                          [DEPRECATED] Please use resize-
		                                   instance instead.
	    resize-instance                        Resizes an instance with a new
		                                   flavor.
	    resize-volume                          Resizes the volume size of an
		                                   instance.
	    restart                                Restarts an instance.
	    show                                   Shows details of an instance.
	    update                                 Updates an instance: Edits name,
		                                   configuration, or replica source.
	    limit-list                             Lists the limits for a tenant.
	    root-enable                            Enables root for an instance and
		                                   resets if already exists.
	    root-show                              Gets status if root was ever
		                                   enabled for an instance.
	    schedule-create-backup                 Create a new schedule for an
		                                   instance.
	    schedule-delete                        Delete a schedule.
	    schedule-list                          List schedules.
	    schedule-show                          Get a schedule.
	    schedule-update                        Update a schedule
	    user-create                            Creates a user on an instance.
	    user-delete                            Deletes a user from an instance.
	    user-grant-access                      Grants access to a database(s) for
		                                   a user.
	    user-list                              Lists the users for an instance.
	    user-revoke-access                     Revokes access to a database for a
		                                   user.
	    user-show                              Shows details of a user of an
		                                   instance.
	    user-show-access                       Shows access details of a user of
		                                   an instance.
	    user-update-attributes                 Updates a user's attributes on an
		                                   instance.
	    versions-list                          Lists versions.

	Optional arguments:
	  --version                                Show cdbclient version.
	  --debug                                  Print debugging output.
	  --insecure                               Don't validate SSL Certs
	  --json                                   Output JSON instead of prettyprint.
		                                   Defaults to env[OS_JSON_OUTPUT].
	  --bypass-url <bypass-url>                Defaults to env[TROVE_BYPASS_URL].
	  --retries <retries>                      Number of retries.
	  --os-auth-system <auth-system>           Defaults to env[OS_AUTH_SYSTEM].
	  --os-username <auth-username>            Username to authenticate with
		                                   Defaults to env[OS_USERNAME].
	  --os-password <auth-password>            Password to authenticate with
		                                   Defaults to env[OS_PASSWORD].
	  --os-tenant-id <tenant-id>, --os-tenant-name <tenant-id>
		                                   Tenant to request authorization on.
		                                   Defaults to env[OS_TENANT_ID].
	  --os-auth-token OS_AUTH_TOKEN            Defaults to env[OS_AUTH_TOKEN]
	  --os-auth-url OS_AUTH_URL                Defaults to env[OS_AUTH_URL]
	  --os-cacert OS_CACERT                    Specify ca cert to use.Defaults to
		                                   env[OS_CACERT]
	  --os-region-name <region-name>           Specify the region to use. Defaults
		                                   to env[OS_REGION_NAME].
	  --endpoint-type <endpoint-type>          Defaults to
		                                   env[TROVE_ENDPOINT_TYPE]
	  --service-type <service-type>            Defaults to database for most
		                                   actions.
	  --service-name <service-name>            Defaults to
		                                   env[TROVE_SERVICE_NAME].

	See "cdb-cli help COMMAND" for help on a specific command.

You can also use `supernova <environemnt> help <command>`
For example, getting help on the list command:

	(cdbclient) customer@cloudserver:~$ supernova cdb-iad help list
	[SUPERNOVA] Running cdb-cli against cdb-iad...
	usage: cdb-cli list [--limit <limit>] [--marker <ID>]
		            [--include-replicas <include_replicas>]
		            [--include-ha <include_ha>] [--include-clustered]

	Lists all the instances.

	Optional arguments:
	  --limit <limit>                        Limit the number of results
		                                 displayed.
	  --marker <ID>                          Begin displaying the results for IDs
		                                 greater than the specified marker.
		                                 When used with --limit, set this to
		                                 the last ID displayed in the previous
		                                 run.
	  --include-replicas <include_replicas>  Include instances which are replicas
		                                 (default 'true').
	  --include-ha <include_ha>              Include instances which are part of a
		                                 HA setup (default 'true').
	  --include-clustered                    Include instances that are part of a
		                                 cluster (default false).


###Common Reasons to Need The API
The Rackspace Control Panel is a nice GUI for many interactions with the product. But not everything you want or need to do is available in the Control Panel. (yet)

####Enable the root MySQL user[WITH DISCLAIMER]
Before you do anything, please make sure you take a backup, and have regularly scheduled backups. ( https://support.rackspace.com/how-to/scheduled-backups-for-cloud-databases/ )

**You can easily break a Cloud Database with the 'root' MySQL user.**

Common Pitfalls

- Do not overwrite a Cloud Database Instance 'MySQL', 'performance_schema' & 'information_schema' Database
- Do not alter the users 'root'@'localhost','os_admin','debian-maint', and 'raxmon'
- Do not use the root user for anything other than administration.
- Remember that the root-user will bypass read-only mode on a mysql replica.

**You Can Always Contact Rackspace Support**
If you're hesitant about anything pertaining to a root user on a Cloud Database, please do not hesitate to open a support ticket or calling our phone support team.

Now that you appreciate the power you're requesting, lets get it.

`supernova cdb-iad root-enable <Instance UUID>`

Example usage and output.

	(cdbclient) customer@cloudserver:~$ supernova cdb-iad root-enable db870d4f-02b3-4173-bd3a-0b376c7ea075
	[SUPERNOVA] Running cdb-cli against cdb-iad...
	+----------+--------------------------------------+
	| Property | Value                                |
	+----------+--------------------------------------+
	| name     | root                                 |
	| password | 4AZxpPHyTX6Qf4a4UxEwGw7wamRcCwn8Xatw |
	+----------+--------------------------------------+

(This instance has since been deleted.)

####Apply a Configuration to an HA Group
If you're not familiar with making configurations for mysql instances, please look here (https://support.rackspace.com/how-to/managing-cloud-databases-configuration-groups-in-the-cloud-control-panel/)

Once you have your configuration ready to apply for an HA cluster, it's very simple to apply it to an HA-Group.

1. First we're going to get the configuration-id.

		(cdbclient) customer@cloudserver:~$ supernova cdb-dfw configuration-list
		[SUPERNOVA] Running cdb-cli against cdb-dfw...
		+--------------------------------------+---------------------+-------------+----------------+------------------------+
		| ID                                   | Name                | Description | Datastore Name | Datastore Version Name |
		+--------------------------------------+---------------------+-------------+----------------+------------------------+
		| 0fd2c356-519c-4484-a502-9034d3d456a8 | customConfiguration | None        | mysql          | 5.6                    |
		+--------------------------------------+---------------------+-------------+----------------+------------------------+

2. Get the HA Group ID.

ha-mysql-list is broken on customer facing package. Jira Created. https://jira.rax.io/browse/DSMYSQL-983

3. Apply Configuration to HA.
4. Restart HA Group
