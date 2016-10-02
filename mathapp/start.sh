#!/bin/bash

cd "$ACC_HOME"

if [ "${ACC_ENABLED}" == "true" ] ; then
    # Enable ACC in the profile
    sed -i 's|introscope.agent.acc.enable=.*|introscope.agent.acc.enable=true|' "$CATALINA_HOME/wily/core/config/IntroscopeAgent.profile"
    # Set ACC config server
    sed -i "s|configurationServer.url=.*|configurationServer.url=$ACC_CS|" "APMCommandCenterController/config/apmccctrl.properties"
    # Start ACC Controller (in background)
    ./APMCommandCenterController/apmccctrl.sh start
fi

# start Tomcat (in foreground)
# exec $CATALINA_HOME/bin/catalina.sh run
$CATALINA_HOME/bin/catalina.sh run
