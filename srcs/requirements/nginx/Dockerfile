FROM debian:buster

RUN apt-get -y update
RUN apt-get -y install dumb-init
RUN apt-get -y install nginx

# Generate DH Params (used for ssl key exchange?)
RUN openssl dhparam 4096 -out /etc/nginx/certs/dhparam.pem

COPY nginx.conf /etc/nginx/sites-available/default

EXPOSE 80/tcp

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
