#!/bin/sh
 ##
 # Tart Database Operations
 # Simple MySQL Parallel Dump & Restore
 #
 # @author      Emre Hasegeli <hasegeli@tart.com.tr>
 # @date        2011-05-23
 ##

echo "Restoring schema from \""$1".schema.sql\" to "$2" database..."
mysql $2 < $1".schema.sql"

chmod o-r $1"."*
chmod o-r $1".data"/*

echo "Restoring data from \""$1".data\" to "$2" database..."
for table in $1".data"/*
	do
		if [ -s $table ]
			then
				mysql -e "Set unique_checks = 0;
						Set foreign_key_checks = 0;
						Load data infile '"$(pwd)/$table"' into table "${table#$1".data/"} $2 &
			fi
	done
wait

chmod o-r $1"."*
chmod o-r $1".data"/*

exit 0
