FROM debian:buster

RUN apt-get update
# Install dumb-init for handling PID 0 and Zombie Proccesses
RUN apt-get install -y --quiet \
		dumb-init
# Install nginx and openssl for the webserver and certificates
RUN apt-get install -y --quiet --no-install-recommends --no-install-suggests \
		nginx \
		openssl

# Generate DH Params (used for ssl key exchange?)
RUN openssl dhparam 4096 -out /etc/nginx/certs/dhparam.pem

COPY nginx.conf /etc/nginx/sites-available/default

EXPOSE 80/tcp

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
