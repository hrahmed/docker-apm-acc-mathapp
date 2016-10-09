FROM tomcat:7-jre8

MAINTAINER guenter.grossberger@ca.com

ENV PROXY_HOST=localhost
ENV PROXY_PORT=8088
ENV SIMPLE_HOST=localhost
ENV SIMPLE_PORT=8088
ENV COMPLEX_HOST=localhost
ENV COMPLEX_PORT=8088
ENV DOTNET_HOST=localhost
ENV DOTNET_PORT=8088
ENV NODE_HOST=localhost
ENV NODE_PORT=8088

ENV WILY_HOME=$CATALINA_HOME/wily
ENV INTROSCOPE_VERSION=10.3.0.15
ENV EM_HOST=manager
ENV EM_PORT=5001
ENV AGENT_NAME=MathApp
ENV HEAP=2048m

# install mathapp application
COPY MathClient.war MathComplexBackend.war MathProxy.war MathSimpleBackend.war $CATALINA_HOME/webapps/

COPY tomcat-users.xml $CATALINA_HOME/conf

# install agent
ADD IntroscopeAgentFiles-NoInstaller${INTROSCOPE_VERSION}tomcat.unix.tar $CATALINA_HOME

# brownser agent
ENV BROWSER_AGENT_ENABLED=false
ENV AXA_BROWSER_AGENT_ENABLED=true
ENV AXA_SCRIPT="<script type="text/javascript" id="ca_eum_ba" agent=browser src="https://axa.trials.ca.com/mdo/v1/sdks/browser/BA.js" data-profileUrl="https://collector.axa.trials.ca.com/profiles/HAROON.AHMED%40CA.COM-C/mathapp-web?agent=browser" data-tenantID="HAROON.AHMED@CA.COM-C" data-appID="mathapp-web" data-appKey="39b9b850-8915-11e6-bfa9-a9dcb512d6bd" ></script>"

# configure CA APM java agent
COPY setenv.sh $CATALINA_HOME/bin/setenv.sh
COPY update-jsps.sh $CATALINA_HOME/update-jsps.sh

# install and configure ACC
ENV ACC_CS=http://configserver:8888
ENV ACC_HOME=/root
ENV ACC_ENABLED=true

COPY start.sh $ACC_HOME/

ADD acc-controller-package.tar $ACC_HOME/

EXPOSE 8088

CMD ["/root/start.sh"]
