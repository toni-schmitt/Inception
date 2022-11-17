#!/bin/bash

set -ex

if [ ! -f ${WP_ROOT_DIR}/wp-config.php ];
	then

	echo "No wordpress Installation found, installing..."

	sleep 3;

	wp --allow-root core download
	# wp --allow-root --path=${WP_ROOT_DIR} config create \
	# 		--dbhost=${WP_DB_HOST} \
	# 		--dbname=${WP_DB_NAME} \
	# 		--dbuser=${WP_DB_USER} \
	# 		--dbpass=${WP_DB_PASS}
	wp --allow-root --path=${WP_ROOT_DIR} core install \
			--url=${WP_URL} \
			--title=${WP_TITLE} \
			--addmin_user=${WP_ADM_USR} \
			--admin-password=${WP_ADM_PASS} \
			--admin_email=${WP_ADM_EMAIL}

	echo "Finished with wordpress installation"
fi

echo "Executing $@"
exec $@