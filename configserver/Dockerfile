# Install configserver

# Use the same base image as we use for the agent/controller to 
# save image duplication. We don't actually want or need tomcat, 
# but we just need a base image with a JVM on it.
FROM jeanblanchard/busybox-java:7

MAINTAINER james.hilling@ca.com

USER root
ENV ACC_ROOT=/root
WORKDIR /root

# controller package tar needs to be available in the same directory as this Dockerfile!
COPY acc-configserver-package.tar /tmp/
RUN tar xf /tmp/acc-configserver-package.tar

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

CMD ["/root/APMCommandCenterServer/apmccsrv.sh", "console"]
