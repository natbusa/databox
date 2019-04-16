SHELL := /bin/bash
ROOT_DIR = $(dir $(lastword $(MAKEFILE_LIST)))
TEST_DEMOS = $(ls demos)

#include .env file (see .env.sample for reference)
-include $(ROOT_DIR)/.env
export

install:
	@$(ROOT_DIR)/scripts/install.sh

build:
	cd $(ROOT_DIR)/docker/containers/hadoop; make build
	cd $(ROOT_DIR)/docker/containers/hive; make build
	cd $(ROOT_DIR)/docker/containers/pyspark-notebook; make build

list-demos:
	@echo "List of demos":
	@ls -1 demos

list-components:
	@echo "List of components":
	@ls -1 docker

up:
	# docker-compose up
	$(ROOT_DIR)/scripts/up.sh --demo=$(DEMO)

down:
	# docker-compose down. Leave network and volumes
	$(ROOT_DIR)/scripts/down.sh --demo=$(DEMO)

purge:
	# docker-compose down. Remove network, volumes and orphan containers
	$(ROOT_DIR)/scripts/down.sh --demo=$(DEMO) --purge

$(TEST_DEMOS):
	make up DEMO=$@; \
	$(ROOT_DIR)/scripts/test.sh --demo=$@;
	make down DEMO=$@

test: $(TEST_DEMOS)
	echo "Regression test done"

clean:
	find $(ROOT_DIR) -name '.ipynb_checkpoints' -exec rm -rf {} +
	find $(ROOT_DIR) -name 'spark-warehouse'    -exec rm -rf {} +

# .DEFAULT_GOAL := up
.PHONY:  up down clean test $(TEST_DEMOS)
.SILENT: up down clean test $(TEST_DEMOS)
