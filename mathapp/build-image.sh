#!/bin/bash

AGENT_FILES=IntroscopeAgentFiles-NoInstaller10.3.0.15tomcat.unix.tar
ACC_PACKAGE=acc-controller-package.tar
MATH_CLIENT=MathClient.war
MATH_PROXY=MathProxy.war
MATH_SIMPLE=MathSimpleBackend.war
MATH_COMPLEX=MathComplexBackend.war

if [ ! -e $AGENT_FILES ] ; then
  echo "$AGENT_FILES is missing. Please download $AGENT_FILES from support.ca.com and place it in this directory."
fi

if [ ! -e $ACC_PACKAGE ] ; then
  echo "$ACC_PACKAGE is missing. Please download CA APM Command Center from support.ca.com, install it and copy $ACC_PACKAGE from the package direcory of the ACC server to this directory."
fi

if [ ! -e $MATH_CLIENT ] ; then
  echo "$MATH_CLIENT is missing. Please download and build MathApp from https://github.com/hrahmed/mathapp-java and copy $MATH_CLIENT to this directory."
fi

if [ ! -e $MATH_PROXY ] ; then
  echo "$MATH_PROXY is missing. Please download and build MathApp from https://github.com/hrahmed/mathapp-java and copy $MATH_PROXY to this directory."
fi

if [ ! -e $MATH_SIMPLE ] ; then
  echo "$MATH_SIMPLE is missing. Please download and build MathApp from https://github.com/hrahmed/mathapp-java and copy $MATH_SIMPLE to this directory."
fi

if [ ! -e $MATH_COMPLEX ] ; then
  echo "$MATH_COMPLEX is missing. Please download and build MathApp from https://github.com/hrahmed/mathapp-java and copy $MATH_COMPLEX to this directory."
fi


sudo=sudo
unamestr=`uname`

#if [[ "$unamestr" == 'Darwin' ]]; then
	sudo=''
#fi

echo "Starting the build"
$sudo docker build -t mathapp-java .
