# Define the path to your docker-compose file
COMPOSE_FILE = .docker/docker-compose.yml
DOCKER_ENV   = .docker/.env.docker
ROOT_LINK    = docker-compose.yml
ROOT_ENV     = .env

COMPOSE_CMD = /usr/bin/docker compose -f $(COMPOSE_FILE) --env-file $(ROOT_ENV) --project-directory . --project-name $(DOCKER_APP_NAME)

.PHONY: link-compose init-env sync-env destroy build rebuild-container build-project \
        up down restart conf ps php-bash web-bash database-bash database-import \
        logs logs-watch log-php test test-pint test-phpstan \
        test-phpunit-coverage reset-ide-helper reset-data fix-pint-and-blade

# Load environment variables from .env if it exists
-include .env
export

# make symlink to docker-compose into the root project .
link-compose:
	@if [ ! -L $(ROOT_LINK) ]; then \
		echo "Creating symbolic link for docker-compose.yml..."; \
		ln -s $(COMPOSE_FILE) $(ROOT_LINK); \
	fi

# create .env if not exists
init-env:
	@if [ ! -f .env.example ]; then \
		echo "Creating .env.example with Docker markers..."; \
		echo "# Start Docker Configuration" > .env.example; \
		echo "" >> .env.example; \
		echo "# End Docker Configuration" >> .env.example; \
	fi
	@if [ ! -f $(ROOT_ENV) ]; then \
		echo "Creating $(ROOT_ENV) from .env.example..."; \
		cp .env.example $(ROOT_ENV); \
	fi

# SYNC: This runs whenever .env.docker changes
sync-env: init-env
	@echo "Updating Docker section in root .env..."
	@# Delete old data between markers in root .env
	@sed -i '/# Start Docker Configuration/,/# End Docker Configuration/{//!d}' $(ROOT_ENV)
	@# Read and insert variables from .env.docker
	@sed -i '/# Start Docker Configuration/r $(DOCKER_ENV)' $(ROOT_ENV)

destroy: sync-env
	$(COMPOSE_CMD) down --rmi all --volumes --remove-orphans
build: sync-env
	$(COMPOSE_CMD) build --build-arg USER_ID=$(shell id -u) --build-arg GROUP_ID=$(shell id -g)
	$(COMPOSE_CMD) up -d --build

rebuild-container:
	@$(MAKE) destroy
	@$(MAKE) build

build-project: sync-env
	$(COMPOSE_CMD) exec --user www-data php bash -c 'COMPOSER=composer.script.json composer run-script reset:backend'
	$(COMPOSE_CMD) exec --user www-data php bash -c 'COMPOSER=composer.script.json composer run-script reset:data'
	$(COMPOSE_CMD) exec --user nginx web bash -c 'rm -rf node_modules && npm i && npm run build'

up: sync-env
	$(COMPOSE_CMD) up -d
down: sync-env
	$(COMPOSE_CMD) down --remove-orphans

restart: sync-env
	@$(MAKE) down
	@$(MAKE) up

conf: sync-env
	$(COMPOSE_CMD) config

ps: sync-env
	docker ps --filter "network=$${DOCKER_APP_NAME}" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Networks}}"
php-bash: sync-env
	$(COMPOSE_CMD) exec --user www-data php bash
web-bash: sync-env
	$(COMPOSE_CMD) exec --user nginx web bash
database-bash: sync-env
	$(COMPOSE_CMD) exec database bash -c 'mysql -u$$MYSQL_USER -p$$MYSQL_PASSWORD'
database-import: sync-env
	$(COMPOSE_CMD) exec -T database bash -c 'mysql -u$$MYSQL_USER -p$$MYSQL_PASSWORD $$MYSQL_DATABASE' < dump.sql

logs: sync-env
	$(COMPOSE_CMD) logs
logs-watch: sync-env
	$(COMPOSE_CMD) logs --follow
log-php: sync-env
	$(COMPOSE_CMD) logs php

reset-ide-helper: sync-env
	$(COMPOSE_CMD) exec -T --user www-data php sh -c 'COMPOSER=composer.script.json composer run-script reset:ide-helper'

reset-data: sync-env
	$(COMPOSE_CMD) exec -T --user www-data php sh -c 'COMPOSER=composer.script.json composer run-script reset:data'

fix-pint-and-blade: sync-env
	$(COMPOSE_CMD) exec -T --user www-data php sh -c 'COMPOSER=composer.script.json composer run-script fix:pint'
	$(COMPOSE_CMD) exec -T --user nginx web sh -c 'npm run fix:blade'

test: sync-env
	$(COMPOSE_CMD) exec -T --user www-data php sh -c 'COMPOSER=composer.script.json composer run-script full:test'

test-pint: sync-env
	$(COMPOSE_CMD) exec -T --user www-data php sh -c 'set -e; COMPOSER=composer.script.json composer run-script test:pint'

test-phpstan: sync-env
	$(COMPOSE_CMD) exec -T --user www-data php sh -c 'COMPOSER=composer.script.json composer run-script test:phpstan'

test-phpunit-coverage: sync-env
	$(COMPOSE_CMD) exec -T --user www-data php sh -c 'COMPOSER=composer.script.json composer run-script test:phpunit-coverage'

test-phpunit-coverage-project: sync-env
	$(COMPOSE_CMD) exec -T --user www-data php sh -c 'COMPOSER=composer.script.json composer run-script test:phpunit-coverage-project'
