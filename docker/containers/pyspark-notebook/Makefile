HADOOP_VERSION = 3.2.0
SPARK_VERSION = 2.4.4

build:
	docker build --build-arg HADOOP_VERSION=$(HADOOP_VERSION) --build-arg SPARK_VERSION=$(SPARK_VERSION) \
		--tag natbusa/pyspark-notebook:$(SPARK_VERSION)-hadoop-$(HADOOP_VERSION) .

publish: build
	#docker push databox-demos/teko-warehouse/pyspark-notebook:$(SPARK_VERSION)-hadoop-$(HADOOP_VERSION) .
