#!/bin/sh

introscopeinstallfile="EPAgent9.7.1.16unix.tar"
errors=false

if [ ! -e $introscopeinstallfile ] ; then
	echo "FATAL: File $introscopeinstallfile does not exist. Please provide this file before building the image"
	errors=true
fi

if [ "$errors" = false ] ; then
	echo "Starting the build"
	docker build -t apm-sample:9.7 .
fi
