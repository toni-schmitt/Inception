#!/bin/bash

# set -ex

echo "Starting Setup for Mariadb"
# If Database Directory does not exist
if [ ! -d "/var/lib/mysql/${DB_NAME}" ];
	then
	echo "No existing Databse found, creating one..."

	echo "Starting mysql Service..."
	# Wait for mysql Service to start
	( service mysql start & ) | grep -q "Service is active"
	echo "Service is active.."

	echo "Configuring mysql (Create DB, User, ...)"
	mysql -u root <<__EOF__
CREATE DATABASE $DB_NAME;
CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON wordpress.* TO '$DB_USER'@'%';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$DB_PASS_ROOT');
__EOF__

	# Sleep a little bit for mysql to proccess everything and then stop
	sleep 3

	echo "Stopping mysql Service..."
	# Wait for mysql Service to stop
	( service mysql stop & ) | grep -q "Service is inactive"
	echo "Service is inactive..."
fi;

echo "Executing $@"
# Execute Arguments
exec $@