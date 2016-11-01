#!/bin/bash
echo ""
##Variables

#MySqlDump Options
MYSQLDUMP_OPTIONS="--routines --triggers --single-transaction"
errLog="/tmp/migrateErrLog"
##Databases to Exclude from Dump
exludeDB="('mysql','information_schema','performance_schema','lost+found')"
excludeUsers="('root','os_admin','debian-sys-maint','raxmon')"

##Building sqlDump Argument
sqlDump="Select schema_name From information_schema.schemata WHERE schema_name NOT IN"
sqlDump="${sqlDump} ${exludeDB}"

##Building UsersDump Argument
usersDump="SELECT CONCAT('SHOW GRANTS FOR ''',user,'''@''',host,''';') FROM mysql.user WHERE user<>'' AND user NOT IN"
usersDump="${usersDump} ${excludeUsers}"

#ListDatabase Function
listDB ()
{
        dbList=""
        for DB in $(mysql $1 -ANe"${sqlDump}" 2>>$errLog)
        do
            dbList="${dbList} ${DB}"
        done
	echo ${dbList} >> $errLog
        echo ${dbList}
}


#MySQLDump Function
##Usage getData "$conDump" "$MYSQLDUMP_OPTIONS" "$(listDB "$conDump")"
##      function <Connection Settings> <Options> <List Of DB's>
getData ()
{
	echo "getDataFiringOff" >> $errLog
	mysqldump ${1} ${2} --databases ${3} 2>> $errLog > /tmp/dbDump.sql 2>> $errLog
	return 0
}
#Stream MySQlDump To Destination
#streamData "$conDump" "$MYSQLDUMP_OPTIONS" "$(listDB "$conDump")" "$dstImp"
streamData ()
{
	echo "streamingData" >> $errLog
	mysqldump ${1} ${2} --databases ${3} 2>> $errLog | mysql ${4} 2>> $errLog
	return 0
}
##Users Dump Function
##
getUsers ()
{
	echo "gettingUsers..." >> $errLog
	mysql ${1} --skip-column-names -A -e"${usersDump}" 2>> $errLog | mysql ${1} --skip-column-names -A 2>> $errLog | sed 's/$/;/g' > /tmp/MySQLUserGrants.sql 2>> $errLog

}

streamUsers ()
{
	echo "streamingUsers..." >> $errLog
	mysql ${1} --skip-column-names -A -e"${usersDump}" 2>> $errLog | mysql ${1} --skip-column-names -A 2>> $errLog | sed 's/$/;/g' | mysql ${2} 2>> $errLog
}


#exportSlowTable ()
#{
#       :
#	cat <<'GO' | mysql --raw --skip-column-names --quick --silent --no-auto-rehash --compress $*
#	SELECT CONCAT(
#	'# Time: ', DATE_FORMAT(start_time, '%y%m%d %H:%i:%s'), CHAR(10),
#	'# User@Host: ', user_host, CHAR(10),
#	'# Query_time: ', TIME_TO_SEC(query_time),
#	'  Lock_time: ', TIME_TO_SEC(lock_time),
#	' Rows_sent: ', rows_sent,
#	'  Rows_examined: ', rows_examined, CHAR(10),
#	'SET timestamp=', UNIX_TIMESTAMP(start_time), ';', CHAR(10),
#	IF(FIND_IN_SET(sql_text, 'Sleep,Quit,Init DB,Query,Field List,Create DB,Drop DB,Refresh,Shutdown,Statistics,Processlist,Connect,Kill,Debug,Ping,Time,Delayed insert,Change user,Binlog Dump,Table Dump,Connect Out,Register Slave,Prepare,Execute,Long Data,Close stmt,Reset stmt,Set option,Fetch,Daemon,Error'),
#	  CONCAT('# administrator command: ', sql_text), sql_text),
#	  ';'
#	  ) AS `# slow-log`
#	  FROM `mysql`.`slow_log`;
#	  GO
#	  echo "#"
#}
#




while [[ $# -gt 0 ]]; do
	key="$1"
	case $key in
		-h|--help)
		echo "Printing Helper..."
		helper=true
		shift # past argument
		;;
		-d|--debug)
		echo "Printer Debug..."
		debug=true
		shift # past argument
		;;	
		--stream)
		echo "MySQLDump will Stream to Destination..."
		stream=true
		shift # past argument
		;;
		--srcuser)
		srcuser="$2"
		shift # past argument
		;;
		--srcpass)
		srcpass="$2"
		shift # past argument
		;;
		--srchost)
		srchost="$2"
		shift # past argument
		;;
		--dstuser)
		dstuser="$2"
		shift # past argument
		;;
		--dstpass)
		dstpass="$2"
		shift # past argument
		;;
		--dsthost)
		dsthost="$2"
		shift
		;;
		*)
		        # unknown option
		;;
	esac
	shift # past argument or value
done


if [ "$helper" = true ]; then
	echo "MySQL Migration Helper"
	echo "----------------------"
	echo "This script should help migrate mysql databases,"
	echo "without breaking Rackspace Specific user accounts,"
	echo "and/or system specific database/tables."
	echo "----------------------"
	echo "Options..."
	echo ""
	echo "--srcuser <String> #Source Database Migration User."
	echo "--srcpass <String> #Source Database Migration Password."
	echo "--srchost <String> #Source Database Hostname/IP address."
	echo "Note: If you don't provide these details, the mysql(dump)"
	echo " commands will be run with default values."
	echo ""
	echo "--dstuser <String> #Destination Database Username."
	echo "--dstpass <String> #Destination Database Password."
	echo "--dsthost <String> #Destination Database Hostname/IP."
	echo ""
	echo "--stream #Direct transfer from the source to destination."
	echo ""
	echo "Note: Destination is required to do full migration."
	echo " If there is no destination configuration, only the"
	echo " MySQLDump and User Grants will be pulled down to '/tmp'."
	exit
fi




if [ -n "$srcuser" ]; then
	echo "Source Username Detected."
	conDump="-u ${srcuser}"
fi

if [ -n "$srcpass" ]; then
	echo "Source Password Detected."
	conDump="${conDump} -p${srcpass}"
fi


if [ -n "$srchost" ]; then
	echo "Source Host Detected."
	conDump="${conDump} -h ${srchost}"
fi


if [ -n "$dstuser" ]; then
	echo "Destination Username Detected."
	dstImp="-u ${dstuser}"
fi

if [ -n "$dstpass" ]; then
	echo "Destination Password Detected."
	dstImp="${dstImp} -p${dstpass}"
fi


if [ -n "$dsthost" ]; then
	echo "Destination Host Detected."
	dstImp="${dstImp} -h ${dsthost}"
fi

if [ "$debug" = true ]; then
	echo "##########################"
	echo "# Argments"
	echo "# #Debug#:" $debug;
	echo "# #Helper:" $helper;
	echo "# srcuser:" $srcuser;
	echo "# srcpass:" $srcpass;
	echo "# srchost:" $srchost;
	echo "# dstuser:" $dstuser;
	echo "# dstpass:" $dstpass;
	echo "# dsthost:" $dsthost;
	echo "# DumpCon:" $conDump;
	echo "# DestCon:" $dstImp;
	echo "##########################"
fi

if [ "$stream" = true ]; then
	echo "Streaming Data..."
	streamData "$conDump" "$MYSQLDUMP_OPTIONS" "$(listDB "$conDump")" "$dstImp"
	echo "Streaming Users..."
	streamUsers "$conDump" "$dstImp"
	echo "Streaming Finished..."
	exit
fi

echo "Getting Dump to /tmp..."

getData "$conDump" "$MYSQLDUMP_OPTIONS" "$(listDB "$conDump")"

echo "Dump to /tmp/dbDump.sql Finished"

echo "Getting User Grants to /tmp..."
getUsers "$conDump"
echo "Users Dumped to /tmp/MySQLUserGrants.sql"



if [ -n "$dstImp" ]; then
	echo "Databases and Users have been exported."
	echo "The following commands will be run:"
	echo "mysql ${dstImp} < /tmp/dbDump.sql 2>> $errLog"
	echo "mysql ${dstImp} < /tmp/MySQLUserGrants.sql 2>> $errLog"

	read -p "Do you want to Import the data?" -n 1 -r
        
	if [[ !$REPLY =~ ^[Yy}$ ]]; then
		mysql ${dstImp} < /tmp/dbDump.sql 2>> $errLog
		mysql ${dstImp} < /tmp/MySQLUserGrants.sql 2>> $errLog
		echo "Data Imported"
	fi
	

fi

