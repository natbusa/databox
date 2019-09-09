# Environment for Demos and Tutorials

 - A collections of demos for the datalabframework package
 - Advanced DevOps techniques
 - Advanced Spark
 - High Productivity techniques
 - CICD for Data Science

## 1. Getting started

This demos require the following tools to be installed.

  - make
  - docker
  - docker-compose

Please clone this repository,
then run `sudo scripts/install.sh` to install the above.

## 2. Build Images
This demo relies on some customized docker containers.
Please run `docker/containers/build.sh`, to build the containers.

## 3. Available demos

Demos are all located under the `demos` directory or
type `ls demos` to print the list of the available demos.

Currently available:

**tutorial**:
An overview of high productivity features for data science and data engineering, using spark and the datalabframework.
Please have a look at [] for getting started with this tutorial.

**retail**:
A Data Engineering ETL/ML/AI Pipeline using the Olist ecommerce data from Kaggle.
(In the making ...)

### 4. Start up the demos

Run `bin/env up <demo-name>`. 
This command will start all the necessary components for the demo.

### 5. Tear down

Stop the environment by typing `bin/env down <demo-name>`.
This will free up all the resources and remove/kill all the running containers

### 6. Requirements
This environment has been tested on Ubuntu 18.04 LTS 64bit with 16GB of RAM.  
Recommended 16 or 32 GB of RAM. The setup works both on Metal and Cloud machines. 

### 7. Workshop!

Tutorial setup a minicluster (single node) with the following components
- postgres(2)
- min.io (1)
- spark (1+2)
- clickhouse(1)
- kafka(1)
- logstash(1)
- kibana(1)
- jupyterlab(1)
- airflow(1)

The tutorial will be done in Python.     
Exploring quite a few libraries for data processing, analytics and machine learning.

Synopsys:
```
- introduce docker, 
- explore top docker cli commands
- introduce docker-compose
- introduce jupyterlab
- quick overview of pandas
- introducing spark
- ingest data into minio (s3) 
- ETL: oltp vs olap
- ETL: dimensional modeling
- build dimensions with spark
- build fact tables with spark
- ETL: dimensions and facts
- slow changing dimension with spark
- ETL: denormalized fact tables
- Exploratory data analysis
- introducing bokeh
- introducing plot.ly
- introducing seaborn
- High productivity:
- Introducing datalabframework
- ETL: build data cubes
- ETL: logging
- Introducing Kafka
- Introducing ELK stack
- ETL: automation
- Introducing Airflow
- ETL: workflows
- Setup and ETL pipeline for Reporting and BI
```
