#!/bin/bash

set -ex

# if [ ! -f ${WP_ROOT_DIR}/wp-config.php ];
# 	then

	echo "No wordpress Installation found, installing..."

	sleep 3;

	wp --allow-root --path=${WP_ROOT_DIR}  core download || true
	# wp --allow-root --path=${WP_ROOT_DIR} config create \
	# 		--dbhost=${DB_HOST} \
	# 		--dbname=${DB_NAME} \
	# 		--dbuser=${DB_USER} \
	# 		--dbpass=${DB_PASSWORD}
	wp --allow-root --path=${WP_ROOT_DIR} core install \
			--url=${WP_URL} \
			--title=${WP_TITLE} \
			--admin_user=${WP_ADM_USR} \
			--admin_password=${WP_ADM_PASS} \
			--admin_email=${WP_ADM_EMAIL}

	echo "Finished with wordpress installation"
# fi

echo "Executing $@"
exec $@