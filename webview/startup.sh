#!/bin/sh

# we need a special startup script, as we need to set the enterprise manager the webview is linked to
# we store the original file to be able to apply the transformation again.
if [ ! -f IntroscopeWebView-orig.properties ]
	then
		cp ${INTROSCOPE_HOME}/config/IntroscopeWebView.properties IntroscopeWebView-orig.properties
fi
cp IntroscopeWebView-orig.properties ${INTROSCOPE_HOME}/config/IntroscopeWebView.properties
sed -i s/EM_HOST_MARKER/${EM_HOST}/g ${INTROSCOPE_HOME}/config/IntroscopeWebView.properties
sed -i s/EM_PORT_MARKER/${EM_PORT}/g ${INTROSCOPE_HOME}/config/IntroscopeWebView.properties
sed -i s/EM_WEB_PORT_MARKER/${EM_WEB_PORT}/g ${INTROSCOPE_HOME}/config/IntroscopeWebView.properties
sed -i s#rest.base=http://{EM_HOST}:{EM_WEBSERVER_PORT}/apm/appmap#rest.base=http://${EM_HOST}:${EM_WEB_PORT}/apm/appmap#g ${INTROSCOPE_HOME}/config/IntroscopeWebView.properties

# activate Java agent
sed -i "s#lax.nl.java.option.additional=#lax.nl.java.option.additional=-javaagent:./product/webview/agent/wily/Agent.jar -Dcom.wily.introscope.agentProfile=./product/webview/agent/wily/core/config/IntroscopeAgent.profile -Dcom.wily.introscope.wilyForWilyPrefix=com.wily -Djetty.home=./ #" ${INTROSCOPE_HOME}/Introscope_WebView.lax

# workaround for agent defect: only IP or FQDN works, not hostname alone
EM_IP_ADDRESS=`nslookup em | awk '/^Address/ { print $3 }' | sed -n '2{p;q}'`
sed -i s#agentManager.url.1=localhost:5001#agentManager.url.1=${EM_IP_ADDRESS}:${EM_PORT}#g ${INTROSCOPE_HOME}/product/webview/agent/wily/core/config/IntroscopeAgent.profile
#sed -i s#agentManager.url.1=localhost:5001#agentManager.url.1=${EM_HOST}:${EM-PORT}#g ${INTROSCOPE_HOME}/product/webview/agent/wily/core/config/IntroscopeAgent.profile


# configure the heap
if [ "${HEAP_XMX}" == "**DEFAULT**" ] ; then
	unset HEAP_XMX
fi
if [ -n "${HEAP_XMX}" ] ; then
	sed -i s/Xmx512m/Xmx${HEAP_XMX}/g ${INTROSCOPE_HOME}/Introscope_Webview.lax
fi

# ha - apply patch before starting
cp /opt/introscope-install/patch/*.jar ${INTROSCOPE_HOME}/product/webview/plugins/

# give EM time to start up
sleep 15

# now we correctly set everything and startup the enterprise manager.
${INTROSCOPE_HOME}/Introscope_WebView
