#!/bin/bash

# copy SPM jars
cp $WILY_HOME/examples/SOAPerformanceManagement/ext/*.jar $WILY_HOME/core/ext

# copy BRTM jars
cp $WILY_HOME/examples/APM/BRTM/ext/*.jar $WILY_HOME/core/ext

# set EM
sed -Ei 's/introscope.agent.enterprisemanager.transport.tcp.host.DEFAULT=localhost/introscope.agent.enterprisemanager.transport.tcp.host.DEFAULT=172.16.241.160/' $WILY_HOME/core/config/IntroscopeAgent.profile

# enable SPM
sed -Ei 's/introscope.autoprobe.directivesFile=tomcat-typical.pbl,hotdeploy/introscope.autoprobe.directivesFile=tomcat-typical.pbl,spm.pbl,hotdeploy/' $WILY_HOME/core/config/IntroscopeAgent.profile

# enable BRTM
sed -Ei 's/#introscope.agent.brtm.enabled=false/introscope.agent.brtm.enabled=true/' $WILY_HOME/core/config/IntroscopeAgent.profile
sed -Ei 's/#brtm.pbd/brtm.pbd/' $WILY_HOME/core/config/tomcat-typical.pbl
