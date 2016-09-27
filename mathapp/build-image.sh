#!/bin/bash

mathclientfile="MathClient.war"
mathproxyfile="MathProxy.war"
mathsimplefile="MathSimpleBackend.war"
mathcomplexfile="MathComplexBackend.war"
errors=false

sudo=sudo
unamestr=`uname`

if [[ "$unamestr" == 'Darwin' ]]; then
	sudo=''
fi

if [ ! -e $mathclientfile ] ; then
	echo "FATAL: File $mathclientfile does not exist. Please provide this file before building the image"
	errors=true
fi

if [ ! -e $mathproxyfile ] ; then
	echo "FATAL: File $mathproxyfile does not exist. Please provide this file before building the image"
	errors=true
fi

if [ ! -e $mathsimplefile ] ; then
	echo "FATAL: File $mathsimplefile does not exist. Please provide this file before building the image"
	errors=true
fi

if [ ! -e $mathcomplexfile ] ; then
	echo "FATAL: File $mathcomplexfile does not exist. Please provide this file before building the image"
	errors=true
fi

if [ "$errors" = false ] ; then
	echo "Starting the build"
	$sudo docker rm mathapp-java
	$sudo docker build -t mathapp-java:1.0 .
fi
