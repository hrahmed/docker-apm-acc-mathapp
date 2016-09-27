#!/bin/sh
# This runs a container in default mode. Note that this expects that the apm-postgres already is started. If you can you should rather use docker-compose (there are some scripts at top level).

docker run -d \
	-p 5001:5001 \
	-p 8081:8081 \
	--link=apm-postgres:db \
	-e HEAP:2048m \
	-v ~/git/docker-introscope/transfer/xmltv:/transfer/xmltv \
	-v ~/git/docker-introscope/transfer/modules:/transfer/modules \
	--name=apm-em \
	apm-em:10.3
