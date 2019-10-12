HADOOP_VERSION = 3.2.1

build:
	docker build --tag natbusa/hadoop:$(HADOOP_VERSION) --build-arg HADOOP_VERSION=$(HADOOP_VERSION) .

publish: build
	#docker push databox-demos/hadoop:$(HADOOP_VERSION)
