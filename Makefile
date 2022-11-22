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

fre: down fclean up

volumes_delete: down
	sudo $(RM) -rf $(DB_VOLUMES_DIR)
	sudo $(RM) -rf $(DATA_VOLUMES_DIR)

cache_clean: down
	docker builder prune --force || true

volume_clean: down
	docker volume rm srcs_mariadb_volume --force
	docker volume rm srcs_wp_php_volume --force
	$(MAKE) volumes_delete

network_clean: down
	docker network rm srcs_inception || true

container_clean: down
	docker container rm nginx --force --volumes
	docker container rm wordpress --force --volumes
	docker container rm mariadb_c --force --volumes

fclean: down cache_clean volume_clean network_clean container_clean
	
sclean: down
	docker system prune -a

logs: mariadb_logs wordpress_logs nginx_logs

mariadb_logs:
	docker logs mariadb_c

wordpress_logs:
	docker logs wordpress

nginx_logs:
	docker logs nginx

exec:
	docker container exec -it $(C) $(CONTAINER) bash -c bash

exec_nginx:
	docker container exec -it nginx bash

nginx_log:
	docker container exec -it nginx cat /var/log/nginx/access.log
	docker container exec -it nginx cat /var/log/nginx/error.log

mariadb_log:
	docker container exec -it mariadb_c cat  /var/log/mysql/error.log