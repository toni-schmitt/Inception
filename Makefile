SRCS_DIR = ./srcs
DOCKER_COMPOSE_FILE = $(SRCS_DIR)/docker-compose.yml

all: up

up: run
start: run
run:
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d

down: stop
stop:
	docker compose -f $(DOCKER_COMPOSE_FILE) down