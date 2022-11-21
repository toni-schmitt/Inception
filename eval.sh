#!/bin/bash

# set -ex

function print_header() {
	local str="$@"

	local blue="\e[34m"
	local reset="\e[0m"

	printf "\n-----------\n"
	printf "$blue$str$reset"
	printf "\n-----------\n"
}

function eval_clean() {
	print_header "Cleaning before Evaluation"

	echo "Stopping Containers..."
	docker stop $(docker ps -qa) || true
	echo "Removing Containers..."
	docker rm $(docker ps -qa) || true
	docker rmi -f $(docker images -qa) || true
	echo "Removing Volumes..."
	docker volume rm $(docker volume ls -q) || true
	echo "Removing Networks..."
	docker network rm $(docker network ls -q) 2>/dev/null || true
}

function is_in_file() {
	local file="$1"
	local to_search="$2"

	local red="\e[31m"
	local green="\e[32m"
	local reset="\e[0m"

	printf "Checking if $to_search is found in $file\n"

	cat "$file" | grep -w -- "$to_search" && printf "$red$to_search found in $file, abort Evaluation now! $reset\n" || printf "$green$to_search not found in $file, continue... $reset\n"
}

clear
print_header "Checking basic stuff asked for in Evaluation Sheet"

eval_clean

DOCKER_COMPOSE_FILE="./srcs/docker-compose.yml"

is_in_file $DOCKER_COMPOSE_FILE "network: host"

is_in_file $DOCKER_COMPOSE_FILE "links:"

MAKEFILE="./Makefile"

is_in_file $MAKEFILE "--link"


print_header "Checking if something illegal is found in Dockerfiles...";
for file in  ./srcs/requirements/*/Dockerfile; do
	is_in_file $file "tail -f"
	is_in_file $file "bash"
	is_in_file $file "ENTRYPOINT *.sh"
	is_in_file $file "FROM nginx"
	is_in_file $file "FROM mariadb"
	is_in_file $file "FROM php"
	is_in_file $file "FROM wordpress"
done;

print_header "Checking if an infinite Loop is found in any Script..."
for file in ./srcs/requirements/*/*.sh; do
	is_in_file $file "while"
	is_in_file $file "sleep infinity"
	is_in_file $file "tail -f /dev/null"
	is_in_file $file "tail -f /dev/random"
done;

