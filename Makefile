SRCS_DIR = ./srcs
DOCKER_COMPOSE_FILE = $(SRCS_DIR)/docker-compose.yml

VOLUMES_DIR = /home/toni/data
DATA_VOLUMES_DIR = $(VOLUMES_DIR)/nginx-php
DB_VOLUMES_DIR = $(VOLUMES_DIR)/db

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


exec_nginx:
	docker container exec -it nginx bash

nginx_log:
	docker container exec -it nginx cat /var/log/nginx/access.log
	docker container exec -it nginx cat /var/log/nginx/error.log