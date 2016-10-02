#!/bin/sh
#

SCRIPT=mathapp-baseline
SCRIPT_DIR=scripts
LOG_DIR=.

JMETER_DIR=.


jmeter -n -t ${SCRIPT_DIR}/${SCRIPT}.jmx -j ${LOG_DIR}/jmeter-${SCRIPT}.log 1>/dev/null &
# -l ${LOG_DIR}/${SCRIPT}.jtl
