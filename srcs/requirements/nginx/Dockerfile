FROM debian:buster

RUN apt-get -y update
RUN apt-get -y install dumb-init
RUN apt-get -y install nginx

COPY default /etc/nginx/sites-available/default

EXPOSE 80/tcp

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
