#!/bin/sh

# we need a special startup script, as we need to set the database within the configuration
# every time we start a container as the linked database could be changed.

integrateClusterMode(){
    sed -i s/introscope.enterprisemanager.clustering.mode=StandAlone/introscope.enterprisemanager.clustering.mode=$1/g ${INTROSCOPE_HOME}/config/IntroscopeEnterpriseManager.properties
}

# tries to read the linked containers and add them to the configuration.
# CDV and MOM share the same configuration entries here.
integrateLinks(){
  # We define that the alias name of any linked container needs to follow the pattern
  # em{no} where {no} is a number starting with 1, and is continuously increasing for each
  # link
  counter=1
  while : ; do
    link_host=$(env | grep ^EM${counter}_PORT_5001_TCP_ADDR | cut -d "=" -f 2)
    link_port=$(env | grep ^EM${counter}_PORT_5001_TCP_PORT | cut -d "=" -f 2)

    if [ -z ${link_host} ] ; then
      if [ ${counter} -eq 1 ] ; then
        echo "found no linked enterprise managers, that comply with the pattern ^EM\{counter\}"
      else
        echo "found no further linked enterprise managers, that comply with the pattern ^EM\{counter\}"
      fi
      break
    fi

    writeLink $counter $link_host $link_port

    counter=$((counter + 1))
  done
}

writeLink(){
  # we want to integrate at the right place in the log file - after the samples
  line_number=$(grep -n "#introscope.enterprisemanager.clustering.login.em1.weight=" ${INTROSCOPE_HOME}/config/IntroscopeEnterpriseManager.properties | cut -d ":" -f 0)
  line_number=$((line_number + 1))

  sed -i "${line_number}i introscope.enterprisemanager.clustering.login.em$1.host=$2" ${INTROSCOPE_HOME}/config/IntroscopeEnterpriseManager.properties
  sed -i "${line_number}i introscope.enterprisemanager.clustering.login.em$1.port=$3" ${INTROSCOPE_HOME}/config/IntroscopeEnterpriseManager.properties

  if [ -z $4 ]; then
    echo "Using default weight (100) for link $1"
    sed -i "${line_number}i introscope.enterprisemanager.clustering.login.em$1.weight=100" ${INTROSCOPE_HOME}/config/IntroscopeEnterpriseManager.properties
  else
    sed -i "${line_number}i introscope.enterprisemanager.clustering.login.em$1.weight=$4" ${INTROSCOPE_HOME}/config/IntroscopeEnterpriseManager.properties
  fi

  if [ -z $5 ]; then
    echo "Using default publickey (internal/server/EM.public) for link $1"
    sed -i "${line_number}i introscope.enterprisemanager.clustering.login.em$1.publickey=internal/server/EM.public" ${INTROSCOPE_HOME}/config/IntroscopeEnterpriseManager.properties
  else
    sed -i "${line_number}i introscope.enterprisemanager.clustering.login.em$1.publickey=$5" ${INTROSCOPE_HOME}/config/IntroscopeEnterpriseManager.properties
  fi

  echo "Added enterprise manager link for index $1 with $2:$3"
}

# read the environment variable to set the correct IP we expect that the database container is linked.
# we store the original file to be able to apply the transformation again.
if [ ! -f tess-db-cfg-orig.xml ]
	then
		cp ${INTROSCOPE_HOME}/config/tess-db-cfg.xml tess-db-cfg-orig.xml
fi
cp tess-db-cfg-orig.xml ${INTROSCOPE_HOME}/config/tess-db-cfg.xml
sed -i s/DATABASE_URL/db/g ${INTROSCOPE_HOME}/config/tess-db-cfg.xml

# install addons
if [ -d /opt/introscope-install/addons/em ] ; then
	cp /opt/introscope-install/addons/em/* ${INTROSCOPE_HOME}/product/enterprisemanager/plugins
fi
if [ -d /opt/introscope-install/addons/workstation ] ; then
	cp /opt/introscope-install/addons/workstation/* ${INTROSCOPE_HOME}/ws-plugins
fi

# copy management modules from linked volume
if [ -d /transfer/modules ] ; then
	cp /transfer/modules/*.jar ${INTROSCOPE_HOME}/config/modules
fi

# copy type viewers from linked volume
if [ -d /transfer/xmltv ] ; then
	cp /transfer/xmltv/*.xml ${INTROSCOPE_HOME}/ext/xmltv
fi

# configure the heap
if [ "${HEAP_XMX}" == "**DEFAULT**" ] ; then
	unset HEAP_XMX
fi
if [ -n "${HEAP_XMX}" ] ; then
	sed -i s/Xmx1024m/Xmx${HEAP_XMX}/g ${INTROSCOPE_HOME}/Introscope_Enterprise_Manager.lax
fi

# increase PermGen
sed -i 's/lax.nl.java.option.additional=/lax.nl.java.option.additional=-XX:MaxPermSize=256m /g' ${INTROSCOPE_HOME}/Introscope_Enterprise_Manager.lax

# Check the clustering role
if [ "${CLUSTER_ROLE}" == "**NONE**" ] ; then
  echo "Starting the Enterprise Manager in Standalone mode"
elif [ "${CLUSTER_ROLE}" == "Collector" ] ; then
  echo "Starting the Enterprise Manager in Collector mode"

  integrateClusterMode "Collector"
elif [ "${CLUSTER_ROLE}" == "MOM" ] ; then
  echo "Starting the Enterprise Manager in MOM mode"

  integrateClusterMode "MOM"
  integrateLinks
elif [ "${CLUSTER_ROLE}" == "CDV" ] ; then
  echo "Starting the Enterprise Manager in CDV mode"

  integrateClusterMode "CDV"
  integrateLinks
else
  echo "Unknown Cluster Flag ${CLUSTER_ROLE} - starting in Standalone mode"
fi

if [ "${REST_API_ENABLE}" == "TRUE" ] ; then
  echo "Enabling REST API"
  sed -i 's/introscope.public.restapi.enabled=false/introscope.public.restapi.enabled=true/' ${INTROSCOPE_HOME}/config/IntroscopeEnterpriseManager.properties
  sed -i 's/log4j.logger.Manager.AppMap.PublicApi=INFO,console,logfile/log4j.logger.Manager.AppMap.PublicApi=INFO,logfile/' ${INTROSCOPE_HOME}/config/IntroscopeEnterpriseManager.properties
  sed -i 's/#introscope.enterprisemanager.webserver.jetty.configurationFile=em-jetty-config.xml/introscope.enterprisemanager.webserver.jetty.configurationFile=em-jetty-config.xml/' ${INTROSCOPE_HOME}/config/IntroscopeEnterpriseManager.properties
  cd ${INTROSCOPE_HOME}/config/internal/server
  keytool -importcert -noprompt -keystore keystore -alias jettyssl -file jettyssl.crt -storepass password
fi


# now we correctly set everything and startup the enterprise manager.
${INTROSCOPE_HOME}/Introscope_Enterprise_Manager
