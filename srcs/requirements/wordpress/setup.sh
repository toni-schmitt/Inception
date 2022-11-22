#!/bin/bash

set -ex

sleep 3;

wp --allow-root --path=${WP_ROOT_DIR}  core download || true
# wp --allow-root --path=${WP_ROOT_DIR} config create \
# 		--dbhost=${DB_HOST} \
# 		--dbname=${DB_NAME} \
# 		--dbuser=${DB_USER} \
# 		--dbpass=${DB_PASSWORD}
if ! wp --allow-root --path=${WP_ROOT_DIR} core is-installed;
	then
	echo "Wordpress core is not installed, installing..."
	wp --allow-root --path=${WP_ROOT_DIR} core install \
			--url=${WP_URL} \
			--title=${WP_TITLE} \
			--admin_user=${WP_ADM_USR} \
			--admin_password=${WP_ADM_PASS} \
			--admin_email=${WP_ADM_EMAIL}
fi;

# Check if User has already been created
if ! wp --allow-root --path=${WP_ROOT_DIR} user get ${WP_USR};
	then
	echo "${WP_USR} not found, creating..."
	# Create User
	wp --allow-root --path=${WP_ROOT_DIR} user create \
			${WP_USR} \
			${WP_USR_EMAIL} \
			--user_pass=${WP_USR_PASS} \
			--role=${WP_USR_ROLE}
fi;

echo "Executing $@"
exec $@