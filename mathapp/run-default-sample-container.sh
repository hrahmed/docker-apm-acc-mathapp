#!/bin/sh


docker run -d \
	-p 8999:8080 \
	--link=apm-configserver:acc \
	--name=mathapp-java \
	mathapp-java:1.0
