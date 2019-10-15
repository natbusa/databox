HADOOP_VERSION = 3.2.1
SPARK_VERSION = 2.4.4

build:
	docker build --build-arg HADOOP_VERSION=$(HADOOP_VERSION) --build-arg SPARK_VERSION=$(SPARK_VERSION) \
		--tag databox/pyspark-notebook:$(SPARK_VERSION)-hadoop-$(HADOOP_VERSION) .
