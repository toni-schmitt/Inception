FROM debian:buster

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
# Install dumb-init for handling PID 0 and Zombie Proccesses
RUN apt-get install -y --quiet \
		dumb-init
# Install nginx and openssl for the webserver and certificates
RUN apt-get install -y --quiet --no-install-recommends --no-install-suggests \
		mariadb-server

# Copy Mariadb Config into Container
COPY mariadb.conf /etc/mysql/mariadb.conf.d/

# Epose Port 3306 for Database
EXPOSE 3306

# Use dumb-init as Entrypoint
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

ARG SETUP_DIR=/home/root/mariadb_setup/
# Create Bin directory in HOME
RUN mkdir -p ${SETUP_DIR}/bin/
ENV PATH="${PATH}:${SETUP_DIR}/bin/"
# Copy setup.sh into Container
COPY setup.sh ${SETUP_DIR}/bin/mariadb_setup.sh
RUN chmod +x ${SETUP_DIR}/bin/mariadb_setup.sh

# Start the mariadb service
CMD ["mariadb_setup.sh", "mysqld_safe"]
