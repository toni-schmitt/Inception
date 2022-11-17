FROM debian:buster

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
# Install dumb-init for handling PID 0 and Zombie Proccesses
RUN apt-get install -y --quiet \
		dumb-init

ARG PHP_VERSION=7.3
# Install PHP
RUN apt-get install -y --quiet --no-install-recommends --no-install-suggests \
		php${PHP_VERSION}-fpm \
		php${PHP_VERSION}-mysql


# Create Link from installed php-fpm binary (with specific Version) to generic php-fpm
RUN ln -s /usr/sbin/php-fpm${PHP_VERSION} /usr/sbin/php-fpm
# Stop PHP-FPM to free port 9000 and later start service
RUN service php${PHP_VERSION}-fpm stop

# Creating Directory for PHP-FPM socket
RUN mkdir -p /run/php/
# Create Directory for PHP-FPM .pid file
RUN mkdir -p /var/run/php/
# TESTING: Just cheking if basic php is working
RUN mkdir -p /var/www/inception
RUN echo "<?php phpinfo(); ?>" >> /var/www/inception/info.php

# Edit PHP Configuration
# Copy PHP-FPM Configuration into Container
COPY www.conf /etc/php/${PHP_VERSION}/fpm/pool.d
# For security reasons: Limit what kind of php-cgi's can be run by the server
RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/${PHP_VERSION}/fpm/php.ini
# Set listen to port 9000 
RUN sed -i "s/listen = \/run\/php\/php$PHP_VERSION_ENV-fpm.sock/listen = 9000/g" /etc/php/7.3/fpm/pool.d/www.conf
RUN sed -i 's/;listen.mode = 0660/listen.mode = 0660/g' /etc/php/7.3/fpm/pool.d/www.conf
RUN sed -i 's/;daemonize = yes/daemonize = no/g' /etc/php/7.3/fpm/pool.d/www.conf

# Wordpress:
RUN apt-get install -y --quiet --no-install-recommends --no-install-suggests \
		wget \
		tar

ARG WP_DOWNLOAD_DIR="/usr/local/bin"
# Download Wordpress CLI Tool
RUN wget --no-check-certificate -P ${WP_DOWNLOAD_DIR} https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x ${WP_DOWNLOAD_DIR}/wp-cli.phar
RUN mv ${WP_DOWNLOAD_DIR}/wp-cli.phar ${WP_DOWNLOAD_DIR}/wp

ARG WP_ROOT_DIR="/var/www/inception/wordpress"
ENV WP_ROOT_DIR=${WP_ROOT_DIR}
# Create Wordpress site's document Root Directory
RUN mkdir -p ${WP_ROOT_DIR}
# Change owner to www-data
RUN chown -R www-data:www-data ${WP_ROOT_DIR}
# Change user and group to www-data
RUN chown www-data:www-data ${WP_ROOT_DIR}
# Copy Wordpress Config to Container
COPY wp-config.php ${WP_ROOT_DIR}

# Use dumb-init as Entrypoint
ENTRYPOINT ["/usr/bin/dumb-init", "--"]


ARG SETUP_DIR=/home/root/wordpress_setup
# Create Bin directory in HOME
RUN mkdir -p ${SETUP_DIR}/bin/
ENV PATH="${PATH}:${SETUP_DIR}/bin/"
# Copy setup.sh into Container
COPY setup.sh ${SETUP_DIR}/bin/wordpress_setup.sh
RUN chmod +x ${SETUP_DIR}/bin/wordpress_setup.sh

EXPOSE 9000

# Run Wordpress Setup and execute php-fpm
CMD ["wordpress_setup.sh", "/usr/sbin/php-fpm", "--nodaemonize"]

# Start the php service
#CMD ["/usr/sbin/php-fpm", "--nodaemonize"]
