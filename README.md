# Docker for CA Wily Introscope
This project hosts docker (https://www.docker.com/) images build for the APM solution of CA Technologies (CA APM).

### Supported components & versions
- Introscope Enterprise Manager (Standalone Mode, MOM Mode, Collector Mode, Cross-cluster viewer Mode)
- Introscope WebView
- Introscope Enterprise Manager database using Postgresql
- APM Control Center (ACC) Configuration Server
- An Introscope sample application (small EPAgent) for demonstration purposes

This version supports Introscope version 10.3. For other versions please look at the branches in the GitHub project. Please feel free to contribute newer versions.

The current idea is to have single-process containers, thus the Enterprise Manager, WebView, Config Server and the APM postgres database are separate images. As docker containers are very light-weight, this is no overhead.

### Prerequisites
- Install Docker (or boot2docker for Mac OSX or Windows): https://docs.docker.com/installation/
- Install Docker Compose: https://docs.docker.com/compose/install/

## Run CA APM in docker containers

Due to legal restrictions we currently cannot make Docker images available for download. Therefore you have to build the Docker images yourself. You can then publish them in an internal registry.

## Run docker images

## Quick start with docker-compose
1. Place the Introscope binaries into the folders. The enterprise manager projects need "introscope10.0.0.12otherUnix.jar" and "osgiPackages.v10.0.0.12.unix.tar".  The ACC Config Server requires acc-configserver-package.tar.
2. Run "sudo docker-compose -f docker-compose--with-sample.yml up". This will start a demonstration environment with one enterprise manager, a database, a webview and a small sample application that delivers some metrics.
3. Access the introscope webview at localhost:8080

## Quick start without docker-compose
Without docker-compose you have to build the images and run the containers yourself.

1. Place the introscope dependencies (see Quick start with docker-compose step 1)

2. Manually build all images. You can use the shell script "create-images.sh"

3. Start the default database container by ./database/run-default-postgres-container.sh

4. Start the enterprise manager container by ./enterprise-manager/run-default-em-container.sh

5. Start the sample application container by ./sample/run-default-sample-container.sh

6. Start the web view container by ./webview/run-default-webview-container.sh

7. Access the introscope webview at localhost:8080

8. Start the ACC Config Server container by ./configserver/run-default-configserver-container.sh

9. Access the ACC Config Server UI at https://localhost:8443


## Using docker-compose

The project already provides many docker-compose definition files. Each definition file describes its use case. If you need to manage a bigger environment docker-compose might be exactly the thing to look for.

## The Enterprise Manager image

### Configuring the Enterprise manager mode
The docker image supports to start an enterprise manager as Standalone, as Collector, as MOM or as CDV. Use the environment variable "CLUSTER_ROLE" and set it to "CDV", "MOM", "Collector" or "Standalone" (with standalone being the default).

### Linking Collectors
For MOMs and CDVs it is necessary to configure the collectors that they are referring to. This is realized by docker links.

As the enterprise manager also links its database via docker links, collectors being linked need to be differentiated. This is currently realized by having a naming scheme for collector links. For each collector link, the link alias needs to be in the format em[number], where number starts with 1 and is a continuously increasing integer.

Have a look at the docker-compose-CDV file for an example of how to name the linked collectors:

```
cdv:
  build: enterprise-manager
  links:
    - cdvdb:db
    - collector1:em1
    - collector2:em2
  environment:
    - HEAP=1024m
    - CLUSTER_ROLE=CDV
```


### Configuring the management module location

There are two ways to manage management modules with this image. The quick approach is to "mount" a local folder that is then used as management module folder. Drawback of this approach is, that the local folder overwrites the management module folder of the enterprise manager. So you need to place the out-of-the-box management modules in this folder as well.

```
docker run -d --name introscope-em --link introscope-db:db -v [localfolder]:/root/Introscope/config/modules stefansiegl/introscope-em:10.0.0.12
```

The second approach allows to add management modules to the existing config/modules folder. The startup script of the container ensures that all files that are within /transfer/modules (in the container) are copied to the config/modules folder. Thus you could keep the management modules you want to integrate locally in a folder and run the container like this (note that the management modules you copied to the container are persisted):

```
docker run -d --name introscope-em --link introscope-db:db -v [localfolder_containing_MM]:/transfer/modules stefansiegl/introscope-em:10.0.0.12
```

### Installing Plugins
The enterprise manager allows to install additional plugins. This image allows this during the build. Simply place your extensions in the folder addons/em and addons/workstation.

### Additional configuration with environment variables
Additional configuration is possible with environment variables. This image currently supports the following:

ENV | description | default | example
---|---|---|---|
HEAP_XMX | sets the xmx heap of the EM. Use typical Java notation. | 1024m | 2048m

Environment variables can be set for example by

```
-e HEAP_XMX="2048m"
```

Topic | description
---|---|
Binaries | Place introscope[version]otherUnix.jar (example: introscope10.0.0.12otherUnix.jar) and osgiPackages.[version].unix.tar (example: osgiPackages.v10.0.0.12.unix.tar) in the folder
Build    | Execute build-image.sh
Run      | Execute run-default-em-container.sh (or use docker-compose - recommended)

## Enterprise Manager database image

This image is built with the idea that the ports are not provided to the open (no -P flag for starting the container). docker links will allow the enterprise manager to access the database nonetheless.

Data is currently written to the "postgres" schema with the postgres user. As nobody else should use this database I expect this to be fine and it makes it easier for me as I did not have to create users and schematas.

Topic | description
---|---|
Binaries | -
Build    | Execute build-image.sh
Run      | Execute run-default-postgres-container.sh (or use docker-compose - recommended)

## WebView image

Basically this image mirrors the enterprise manager in many ways. I figured that it might be easier to have this as a separate image and not within the enterprise-manager image as this would complicate the scripts.

Topic | description
---|---|
Binaries | Place introscope[version]otherUnix.jar (example: introscope10.0.0.12otherUnix.jar) and osgiPackages.[version].unix.tar (example: osgiPackages.v10.0.0.12.unix.tar) in the folder
Build    | Execute build-image.sh
Run      | Execute run-default-webview-container.sh (or use docker-compose - recommended)

## Sample image

This is really just a very small EPAgent sample application. I included this, as I want to have a sample application for testing purposes. So I thought why not put it here as well.

Topic | description
---|---|
Binaries | Place EPAgent[version]unix.tar (example: EPAgent10.0.0.12unix.tar) in the folder
Build    | Execute build-image.sh
Run      | Execute run-default-sample-container.sh (or use docker-compose - recommended)


## Locking at the data inside the containers (e.g. logs)
If you like you can also map local folders (volumes), but I don't like this approach as this hinders portability, and most of the time it is not even necessary, as docker is great at providing access to them already. What I usually do is to connect to the container with either
```
docker logs [container-name] (to see all log output written to system out)
```

or you can even get our own shell on the container by

```
docker exec -it [container-name] /bin/sh
```

## Using an internal registry

### Instruct docker to trust our internal registry
This tells docker to trust the self-signed certificate of the internal registry.

#### On Linux
1. Run
```
sudo mkdir -p /etc/docker/certs.d/apm-docker-registry.ca.com:5000
sudo wget 'https://cawiki.ca.com/download/attachments/729866722/ca.crt?version=1&modificationDate=1437193573915&api=v2' -O /etc/docker/certs.d/apm-docker-registry.ca.com:5000/ca.crt`
```
2. Restart docker: this is usually `service docker stop && service docker start`

#### On OSX or Windows with boot2docker
1. First run `boot2docker ssh "echo $'EXTRA_ARGS=\"--insecure-registry bleep:5000\"' | sudo tee -a /var/lib/boot2docker/profile && sudo /etc/init.d/docker restart"`
2. Run the commands from step 1 above inside the boot2docker vm
3. Restart boot2docker: `boot2docker stop && boot2docker up`

### Test access to docker registry

Run `(sudo) docker pull apm-docker-registry.ca.com:5000/hello-world`

If you get an error like
```
FATA[0001] Error response from daemon: v1 ping attempt failed with error: Get https://apm-docker-registry:5000/v1/_ping: tls: oversized record received with length 20527. If this private registry supports only HTTP or HTTPS with an unknown CA certificate, please add `--insecure-registry apm-docker-registry:5000` to the daemon's arguments. In the case of HTTPS, if you have access to the registry's CA certificate, no need for the flag; simply place the CA certificate at /etc/docker/certs.d/apm-docker-registry:5000/ca.crt
```
you have not set up docker correctly to trust the certficate of the registry. Repeat the steps above and make sure to restart docker.

### Download and run docker images
Run `docker-compose up -d`. This will download the images from the docker registry and start three containers for the EM, WebView and APM DB respectively.



## Legal notice: binaries not included
As Introscope is commercial software I cannot provide fully-built images. Also this project cannot provide the binaries for building the images. But the addition of the binaries is a piece of cake.


## License
This field pack is provided under the [Eclipse Public License, Version 1.0](https://github.com/CA-APM/docker-introscope/blob/master/LICENSE).

## Support
This document and associated tools are made available from CA Technologies as examples and provided at no charge as a courtesy to the CA APM Community
at large. This resource may require modification for use in your environment. However, please note that this resource is not supported by CA Technologies,
and inclusion in this site should not be construed to be an endorsement or recommendation by CA Technologies. These utilities are not covered by the
CA Technologies software license agreement and there is no explicit or implied warranty from CA Technologies. They can be used and distributed freely
amongst the CA APM Community, but not sold. As such, they are unsupported software, provided as is without warranty of any kind, express or implied,
including but not limited to warranties of merchantability and fitness for a particular purpose. CA Technologies does not warrant that this resource
will meet your requirements or that the operation of the resource will be uninterrupted or error free or that any defects will be corrected. The use
of this resource implies that you understand and agree to the terms listed herein.

Although these utilities are unsupported, please let us know if you have any problems or questions by adding a comment to the CA APM Community Site area where the resource is located, so that the Author(s) may attempt to address the issue or question.

Unless explicitly stated otherwise this field pack is only supported on the same platforms as the APM core agent. See [APM Compatibility Guide](http://www.ca.com/us/support/ca-support-online/product-content/status/compatibility-matrix/application-performance-management-compatibility-guide.aspx).


### Support URL
https://github.com/CA-APM/docker-introscope/issues


## Categories
Cloud, Examples, Virtualization/Containers
