#!/bin/sh
# This runs a container in default mode. Note that this expects that apm-em already is started

docker run -d \
	-p 8082:8080 \
	--link=apm-em:em \
	--name=apm-webview \
	apm-webview:10.3
