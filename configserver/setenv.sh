#!/bin/sh

# set EM host and port
sed -Ei "s/agentManager.url.1=.*/agentManager.url.1=${EM_HOST}:${EM_PORT}/" $WILY_HOME/wily/core/config/IntroscopeAgent.profile

introscope.agent.customProcessName=Tomcat

# enable Browser Agent
if [ "${BROWSER_AGENT_ENABLED}" == "true" ] ; then
  sed -Ei 's/introscope.agent.browseragent.enabled=.*/introscope.agent.browseragent.enabled=true/' $WILY_HOME/wily/core/config/IntroscopeAgent.profile
  sed -Ei 's/introscope.agent.browseragent.geolocation.enabled=false/introscope.agent.browseragent.geolocation.enabled=true/' $WILY_HOME/wily/core/config/IntroscopeAgent.profile
else
  sed -Ei 's/introscope.agent.browseragent.enabled=.*/introscope.agent.browseragent.enabled=false/' $WILY_HOME/wily/core/config/IntroscopeAgent.profile
fi

# agent properties
sed -Ei 's/introscope.agent.deep.instrumentation.level=low/introscope.agent.deep.instrumentation.level=high/' $WILY_HOME/wily/core/config/IntroscopeAgent.profile
sed -Ei 's/introscope.agent.remoteagentdynamicinstrumentation.enabled=false/introscope.agent.remoteagentdynamicinstrumentation.enabled=true/' $WILY_HOME/wily/core/config/IntroscopeAgent.profile

# set agent hostname
if [ -n "$AGENT_HOSTNAME" ]; then
    AGENT_HOSTNAME_ARG="-Dintroscope.agent.hostName=${AGENT_HOSTNAME}"
else
    AGENT_HOSTNAME_ARG=""
fi

# now add the APM agent to ACC configuration file
sed -i -e '$a\ ' ${ACC_ROOT}/APMCommandCenterServer/config/apmccsrv.properties
sed -i -e '$a\#################################################################' ${ACC_ROOT}/APMCommandCenterServer/config/apmccsrv.properties
sed -i -e '$a\##### Additional APM Agent Properties to monitor ACC ############' ${ACC_ROOT}/APMCommandCenterServer/config/apmccsrv.properties
sed -i -e '$a\wrapper.java.additional.23=-Dcom.wily.introscope.agent.agentName=Server1' ${ACC_ROOT}/APMCommandCenterServer/config/apmccsrv.properties
sed -i -e '$a\wrapper.java.additional.24=-Dintroscope.agent.customProcessName=ACC' ${ACC_ROOT}/APMCommandCenterServer/config/apmccsrv.properties
sed -i -e '$a\wrapper.java.additional.25=-Dcom.wily.introscope.agentProfile=/root/wily/core/config/IntroscopeAgent.profile' ${ACC_ROOT}/APMCommandCenterServer/config/apmccsrv.properties
sed -i -e '$a\wrapper.java.additional.26=-javaagent:/root/wily/Agent.jar' ${ACC_ROOT}/APMCommandCenterServer/config/apmccsrv.properties
sed -i -e '$a\spring.http.gzip.enabled=false' ${ACC_ROOT}/APMCommandCenterServer/config/apmccsrv.properties
sed -i -e '$a\spring.http.gzip.minGzipSize=999999999' ${ACC_ROOT}/APMCommandCenterServer/config/apmccsrv.properties
sed -i -e '$a\ ' ${ACC_ROOT}/APMCommandCenterServer/config/apmccsrv.properties
