#!/bin/bash

# enable AXA Browser agent
if [ "${AXA_BROWSER_AGENT_ENABLED}" == "true" ] ; then
  #unzip $CATALINA_HOME/webapps/MathClient.war -d $CATALINA_HOME/webapps/MathClient

  sed -Ei 's,<head>,& '"$AXA_SCRIPT"',' $CATALINA_HOME/webapps/MathClient/operation.jsp
  sed -Ei 's,<head>,& '"$AXA_SCRIPT"',' $CATALINA_HOME/webapps/MathClient/login.jsp
  sed -Ei 's,<head>,& '"$AXA_SCRIPT"',' $CATALINA_HOME/webapps/MathClient/logout.jsp
  sed -Ei 's,<head>,& '"$AXA_SCRIPT"',' $CATALINA_HOME/webapps/MathClient/error.jsp
fi
