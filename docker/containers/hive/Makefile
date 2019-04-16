HADOOP_VERSION = 3.1.1

build:
	docker build --tag datalabframework-demos/hive:$(HADOOP_VERSION) --build-arg HADOOP_VERSION=$(HADOOP_VERSION) .

publish: build
	#docker push datalabframework-demos/teko-warehouse/hive:$(HADOOP_VERSION) .
