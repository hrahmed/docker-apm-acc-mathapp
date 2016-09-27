#!/bin/bash

# start tomcat to unpack war files
/usr/local/tomcat/bin/catalina.sh start
sleep 15s

# redirect to node container
# sed -Ei 's/localhost:3000/192.168.59.103:3000/' /usr/local/tomcat/webapps/tixchangeNode/index.html
# sed -Ei 's/localhost:4000/192.168.59.103:4000/' /usr/local/tomcat/webapps/tixchangeNode/index.html

# stop tomcat
/usr/local/tomcat/bin/catalina.sh stop
sleep 15s
