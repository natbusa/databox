HADOOP_VERSION = 3.1.1

build:
	docker build --tag datalabframework-demos/hadoop:$(HADOOP_VERSION) --build-arg HADOOP_VERSION=$(HADOOP_VERSION) .

publish: build
	#docker push datalabframework-demos/hadoop:$(HADOOP_VERSION)
