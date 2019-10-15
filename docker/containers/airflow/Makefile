AIRFLOW_VERSION = 1.10.4

build:
	docker build --rm --build-arg AIRFLOW_VERSION=$(AIRFLOW_VERSION) -t databox/docker-airflow:$(AIRFLOW_VERSION) .
