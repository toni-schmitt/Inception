#!/bin/bash

function exec_cmd_as_www_data() {
	su - www-data -s /bin/bash -c "$*"
}

cd ${WP_ROOT_DIR}
exec_cmd_as_www_data wp core download

exec_cmd_as_www_data wp core install --url="$WP_URL" --title="$WP_TITLE" --addmin_user="$WP_ADM_USR" --admin-password="$WP_ADM_PASS" --admin_email="$WP_ADM_EMAIL"

exec $@