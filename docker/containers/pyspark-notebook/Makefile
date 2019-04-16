HADOOP_VERSION = 3.1.1
SPARK_VERSION = 2.4.1

build:
	docker build --build-arg HADOOP_VERSION=$(HADOOP_VERSION) --build-arg SPARK_VERSION=$(SPARK_VERSION) \
		--tag datalabframework-demos/pyspark-notebook:$(SPARK_VERSION)-hadoop-$(HADOOP_VERSION) .

publish: build
	#docker push datalabframework-demos/teko-warehouse/pyspark-notebook:$(SPARK_VERSION)-hadoop-$(HADOOP_VERSION) .
