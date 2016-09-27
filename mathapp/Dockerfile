FROM tomcat

MAINTAINER haroon.ahmed@ca.com

ENV WILY_HOME=/usr/local/tomcat/wily
ENV CATALINA_OPTS=-Xmx2048m

ENV ACC_CS=http://accdemowin01.ca.com:8889
ENV ACC_HOME=/root
ENV ACC_ENABLED=true

# Copy MathApp binaries to Tomcat
ADD MathClient.war /usr/local/tomcat/webapps/
ADD MathProxy.war /usr/local/tomcat/webapps/
ADD MathSimpleBackend.war /usr/local/tomcat/webapps/
ADD MathComplexBackend.war /usr/local/tomcat/webapps/

# Add and start ACC controller
ADD acc-controller-package.tar /usr/local
RUN sed -i -e '/configurationServer.url=/ s/=/= http:\/\/accdemowin01.ca.com:8889/' /usr/local/APMCommandCenterController/config/apmccctrl.properties

ADD init_acc-controller.sh /opt/init_acc-controller.sh
RUN /opt/init_acc-controller.sh

# Add and start APM Agent
ADD mathapp_v1.tar /usr/local/tomcat

ENV WILY_HOME=/usr/local/tomcat/wily
ENV CATALINA_OPTS=-Xmx2048m

ADD init_tomcat.sh /opt/init_tomcat.sh
#ADD init_agent.sh /opt/init_agent.sh

RUN /opt/init_tomcat.sh
ADD tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml

# now add the APM agent
ENV CATALINA_OPTS="-Xmx2048m -javaagent:$WILY_HOME/Agent.jar -Dcom.wily.introscope.agentProfile=$WILY_HOME/core/config/IntroscopeAgent.profile -Dcom.wily.introscope.agent.agentName=mathapp -DagentManager.url.1=manager:5001 -DnodeHost=192.168.59.3 -DnodePort=8999"

ADD start-tomcat-acc.sh /opt/init/start-tomcat-acc.sh

#RUN /opt/init_agent.sh

EXPOSE 8080

CMD /opt/init/start-tomcat-acc.sh
