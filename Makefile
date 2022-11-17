SRCS_DIR = ./srcs
DOCKER_COMPOSE_FILE = $(SRCS_DIR)/docker-compose.yml

VOLUMES_DIR = /home/toni/data
DATA_VOLUMES_DIR = $(VOLUMES_DIR)/mariadb_volume
DB_VOLUMES_DIR = $(VOLUMES_DIR)/wp_php_volume

all: up

up: run
start: run
run: volumes
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d --build

down: stop
stop:
	docker compose -f $(DOCKER_COMPOSE_FILE) down

volumes:
	mkdir -p $(DATA_VOLUMES_DIR)
	mkdir -p $(DB_VOLUMES_DIR)

re: down up

logs: mariadb_logs wordpress_logs nginx_logs

mariadb_logs:
	docker logs mariadb

wordpress_logs:
	docker logs wordpress

nginx_logs:
	docker logs nginx

exec_nginx:
	docker container exec -it nginx bash

nginx_log:
	docker container exec -it nginx cat /var/log/nginx/access.log
	docker container exec -it nginx cat /var/log/nginx/error.log