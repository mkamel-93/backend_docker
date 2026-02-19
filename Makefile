# Define the path to your docker-compose file
COMPOSE_FILE = docker-compose.yml
COMPOSE = docker-compose -f $(COMPOSE_FILE) --project-directory .

destroy:
	clear
	$(COMPOSE) down --rmi all --volumes --remove-orphans
build:
	clear
	$(COMPOSE) build --build-arg USER_ID=$(shell id -u) --build-arg GROUP_ID=$(shell id -g)
	$(COMPOSE) up -d --build

rebuild-container:
	clear
	@make destroy
	@make build

up:
	$(COMPOSE) up -d
down:
	$(COMPOSE) down --remove-orphans

restart:
	clear
	@make down
	@make up

conf:
	clear
	$(COMPOSE) config

ps:
	clear
	docker ps --format "table {{.Image}}\t{{.Ports}}"
php-bash:
	clear
	$(COMPOSE) exec --user www-data php bash
web-bash:
	clear
	$(COMPOSE) exec web bash
database-bash:
	clear
	$(COMPOSE) exec database bash -c 'mysql -u$$MYSQL_USER -p$$MYSQL_PASSWORD'
database-import:
	clear
	$(COMPOSE) exec -T database bash -c 'mysql -u$$MYSQL_USER -p$$MYSQL_PASSWORD $$MYSQL_DATABASE' < dump.sql

logs:
	clear
	$(COMPOSE) logs
logs-watch:
	clear
	$(COMPOSE) logs --follow
log-php:
	clear
	$(COMPOSE) logs php
