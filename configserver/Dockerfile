# Install configserver

# Use the same base image as we use for the agent/controller to
# save image duplication. We don't actually want or need tomcat,
# but we just need a base image with a JVM on it.
FROM jeanblanchard/busybox-java:7

MAINTAINER james.hilling@ca.com

USER root
ENV ACC_ROOT=/root
WORKDIR /root

# APM agent
ENV WILY_HOME=/root
ENV INTROSCOPE_VERSION=10.3.0.15
ENV EM_HOST=manager
ENV EM_PORT=5001
ENV AGENT_NAME=ACC

# install agent
ADD IntroscopeAgentFiles-NoInstaller${INTROSCOPE_VERSION}tomcat.unix.tar ${WILY_HOME}

# controller package tar needs to be available in the same directory as this Dockerfile!
COPY acc-configserver-package.tar /tmp/
RUN tar xf /tmp/acc-configserver-package.tar

# brownser agent
ENV BROWSER_AGENT_ENABLED=true
ENV AXA_BROWSER_AGENT_ENABLED=true
ENV AXA_SCRIPT=



# install and configure ACC
ENV ACC_CS=http://localhost:8888
ENV ACC_HOME=/root
ENV ACC_ENABLED=true

#COPY start.sh $ACC_HOME/

# ADD acc-controller-package.tar $ACC_HOME/
# install and configure ACC
ENV ACC_CS=http://localhost:8888
ENV ACC_HOME=/root
ENV ACC_ENABLED=true
ADD acc-controller-package.tar $ACC_HOME/


# script to configure CA APM java agent
COPY setenv.sh ${ACC_HOME}/APMCommandCenterServer/bin/setenv.sh

EXPOSE 8888
EXPOSE 8443
#EXPOSE 8088

# You may wish to keep these paths on volumes to keep data persistent
# across containers invokations.
#VOLUME ["/root/APMCommandCenterServer/data", \
#		"/root/APMCommandCenterServer/import", \
#		"/root/APMCommandCenterServer/bundle", \
#		"/root/APMCommandCenterServer/config", \
#		"/root/APMCommandCenterServer/logs"]

COPY start.sh /root/start.sh

#CMD ["/root/APMCommandCenterServer/apmccsrv.sh", "console"]
CMD ["/root/start.sh"]
