#!/bin/sh

errors=false
INTROSCOPE_VERSION=10.3.0.15
INTROSCOPE_TAR=introscope${INTROSCOPE_VERSION}other.tar
INTROSCOPE_BIN=introscope${INTROSCOPE_VERSION}otherUnix.jar

if [ ! -e $INTROSCOPE_BIN ] ; then
  tar xvopf introscope${INTROSCOPE_VERSION}other.tar ${INTROSCOPE_BIN}
fi

if [ ! -e $INTROSCOPE_BIN ] ; then
  echo "$INTROSCOPE_BIN is missing. Please download $INTROSCOPE_TAR from support.ca.com and place it in this directory."
fi

if [ "$errors" = false ] ; then
	echo "Starting the build"
	docker build -t apm-em:10.3 .
fi
