#!/bin/sh

# Tested with ACC version 10.2.0.23

set -eu

ACC_TAR="acc-configserver-package.tar"

if [ ! -e "$ACC_TAR" ] ; then
  echo "$ACC_TAR is missing. Please download $ACC_TAR from support.ca.com and place it in this directory."
  exit 1
fi

echo "Starting the build"
exec docker build -t "apm-configserver:10.2" .

