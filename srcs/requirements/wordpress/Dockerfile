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

# TESTING: Just cheking if basic php is working
RUN mkdir -p /var/www/inception
RUN echo "<?php phpinfo(); ?>" >> /var/www/inception/info.php

# Use dumb-init as Entrypoint
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# Create Link from installed php-fpm binary (with specific Version) to generic php-fpm
RUN ln -s /usr/sbin/php-fpm${PHP_VERSION} /usr/sbin/php-fpm
# Start the php service
CMD ["/usr/sbin/php-fpm", "--nodaemonize"]
