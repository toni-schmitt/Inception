#!/bin/bash

set -ex

echo "Starting Setup for Mariadb"
# If Database Directory does not exist
if [ ! -d "/var/lib/mysql/${DB_NAME}" ];
	then
	echo "No existing Databse found, creating one..."

	echo "Starting mysql Service..."
	# Wait for mysql Service to start
	( service mysql start & ) | grep -q "Service is active" || true
	echo "Service is active.."

	echo "Configuring mysql (Create DB, User, ...)"
	mysql -u root <<__EOF__
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO 'root'@'%' IDENTIFIED BY '$DB_PASS_ROOT';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$DB_PASS_ROOT');
__EOF__

	# Sleep a little bit for mysql to proccess everything and then stop
	sleep 3

	echo "Stopping mysql Service..."
	# Wait for mysql Service to stop
	( service mysql stop & ) | grep -q "Service is inactive" || true
	echo "Service is inactive..."
fi;

echo "Executing $@"
# Execute Arguments
exec $@