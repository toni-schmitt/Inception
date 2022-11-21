FROM debian:buster

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
# Install dumb-init for handling PID 0 and Zombie Proccesses
RUN apt-get install -y --quiet \
		dumb-init
# Install nginx and openssl for the webserver and certificates
RUN apt-get install -y --quiet --no-install-recommends --no-install-suggests \
		nginx \
		openssl
# Remove all non needed packages and tmp directory
RUN apt-get remove --purge --auto-remove -y --quiet
RUN rm -rf /tmp/* /var/tmp/*

# Generate self-signed TLS Certificate
RUN mkdir -p /etc/nginx/certs
RUN openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
		# '-subj' for non interactive creation
		-subj "/C=DE/ST=BW/L=Heilbronn/O=42 Heilbronn/CN=www.example.com" \
		-keyout /etc/nginx/certs/cert.key -out /etc/nginx/certs/cert.crt

# Copy global config to Container
COPY global_nginx.conf /etc/nginx/nginx.conf

ARG WORDPRESS_CNTR
ENV PHP_SERVICE_ENV=${WORDPRESS_CNTR}
RUN sed -i "s/PHP_SERVICE/${PHP_SERVICE_ENV}/g" /etc/nginx/nginx.conf

# Copy nginx.conf to Container
COPY server_nginx.conf /etc/nginx/conf.d/server.conf


ARG NGINX_ROOT_DIR="/var/www/"
# Create Root Directory for NGINX
RUN mkdir -p ${NGINX_ROOT_DIR}
# Change owner to www-data
RUN chown -R www-data:www-data ${NGINX_ROOT_DIR}
# Change user and group to www-data
RUN chown www-data:www-data ${NGINX_ROOT_DIR}

# Expose Port 443 (https?)
EXPOSE 443

# Use dumb-init as Entrypoint
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# Start the nginx service
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
