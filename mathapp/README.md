# MathApp for Docker

# Description
Run MathApp demo application in Docker container.

## Short Description
Run MathApp demo application in Docker container.

## APM version
Tested with APM 10.3.

## Supported third party versions
n/a

## Limitations
n/a

## License
[Apache License 2.0](LICENSE)

# Installation Instructions

## Prerequisites
* Clone and build [mathapp-java](https://github.com/hrahmed/mathapp-java), copy the 4 war files to the local directory
* Download "Introscope Agent Files for Apache Tomcat-No Installer r10.3.0.0" from [CA Support Online](https://support.ca.com) and put `IntroscopeAgentFiles-NoInstaller10.3.0.15tomcat.unix.tar` in the local directory
* Download and install CA APM Command Center Server 10.3 for Linux or Windows from [CA Support Online](https://support.ca.com) and put copy `acc-controller-package.tar` from the `package` direcory of the ACC server to the local directory

## Dependencies
CA APM 10.3

## Installation
To build the Docker image run `./build-image.sh`

## Configuration
To run the Docker image run `docker run <parameters> mathapp_tomcat`

# Usage Instructions
The following environment variables can be used from the command line or a Docker orchestration tool:
- HEAP: assign more heap memory to the Tomcat JVM, e.g. "3072m"
- EM_HOST: DNS name, IP address or Docker container/service (needs link or same Docker network) of the CA APM Enterprise Manager, e.g. em01.ca.com
- EM_PORT: port to connect to the CA APM Enterprise Manager (MOM), default: 5001
- AGENT_NAME: APM agent name, default "MathApp"
- AGENT_HOSTNAME: is used as the agent hostname instead of the Docker container id, e.g. mathapp_tomcat01
- ACC_ENABLED: enable CA APM Command Center controller agent, default: true
- ACC_CS: url of the CA APM Command Center Configuration Server, e.g. http://accdemowin01.ca.com:8889

You can use the included `baseline.sh` and `stoptest.sh` to create load and stop the load. You need [JMeter](http://jmeter.apache.org) installed locally and need to set the path in `baseline.sh`. Additional JMeter scripts that create error scenarios are included in the `scripts` directory.

## Debugging and Troubleshooting
```
docker logs
docker exec -it <container_name> bash
```

## Support
This document and associated tools are made available from CA Technologies as examples and provided at no charge as a courtesy to the CA APM Community at large. This resource may require modification for use in your environment. However, please note that this resource is not supported by CA Technologies, and inclusion in this site should not be construed to be an endorsement or recommendation by CA Technologies. These utilities are not covered by the CA Technologies software license agreement and there is no explicit or implied warranty from CA Technologies. They can be used and distributed freely amongst the CA APM Community, but not sold. As such, they are unsupported software, provided as is without warranty of any kind, express or implied, including but not limited to warranties of merchantability and fitness for a particular purpose. CA Technologies does not warrant that this resource will meet your requirements or that the operation of the resource will be uninterrupted or error free or that any defects will be corrected. The use of this resource implies that you understand and agree to the terms listed herein.

Although these utilities are unsupported, please let us know if you have any problems or questions by adding a comment to the CA APM Community Site area where the resource is located, so that the Author(s) may attempt to address the issue or question.

Unless explicitly stated otherwise this extension is only supported on the same platforms as the APM core agent. See [APM Compatibility Guide](http://www.ca.com/us/support/ca-support-online/product-content/status/compatibility-matrix/application-performance-management-compatibility-guide.aspx).

### Support URL
https://github-isl-01.ca.com/APMSWAT/mathapp-java-docker/issues

# Contributing
The [CA APM Community](https://communities.ca.com/community/ca-apm) is the primary means of interfacing with other users and with the CA APM product team.  The [developer subcommunity](https://communities.ca.com/community/ca-apm/ca-developer-apm) is where you can learn more about building APM-based assets, find code examples, and ask questions of other developers and the CA APM product team.

If you wish to contribute to this or any other project, please refer to [easy instructions](https://communities.ca.com/docs/DOC-231150910) available on the CA APM Developer Community.

## Categories
Cloud Examples Virtualization/Containers


# Change log
Changes for each version of the extension.

Version | Author | Comment
--------|--------|--------
1.0 | Guenter Grossberger | First version of the extension.
