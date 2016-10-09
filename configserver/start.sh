#!/bin/sh

# Set Env
$ACC_HOME/APMCommandCenterServer/bin/setenv.sh

# Start ACC Controller
cd "$ACC_HOME"

if [ "${ACC_ENABLED}" == "true" ] ; then
    # Enable ACC in the profile
    sed -i 's|introscope.agent.acc.enable=.*|introscope.agent.acc.enable=true|' "$WILY_HOME/wily/core/config/IntroscopeAgent.profile"
    # Set ACC config server
    sed -i "s|configurationServer.url=.*|configurationServer.url=$ACC_CS|" "APMCommandCenterController/config/apmccctrl.properties"
    # Start ACC Controller (in background)
    ./APMCommandCenterController/apmccctrl.sh start
fi

# start ACC Server

/root/APMCommandCenterServer/apmccsrv.sh console
