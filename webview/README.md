# docker-introscope-webview manager
A docker (https://www.docker.com/) image build for the APM solution of CA Technologies (CA APM). This project build a docker image for an Introscope enterprise manager webview in version 10.3. It is meant to be used in combination with the docker image docker-introscope-enterprisemanager (https://github.com/stefansiegl/docker-introscope-enterprisemanager), which provides the enterprise manager.

Note that due to licensing reasons, it is not possible to package the installation files and the license in this image. Please read the usage which file you have to put where.

## Necessary configuration prior to building
The docker image needs the installation files from CA Wily Introscope. Simply copy the file ``introscope10.3.0.15otherUnix.jar`` (installer of the enterprise manager)

It goes without saying that you need docker installed. If you are on Windows (like me) or Mac, you can use boot2docker - I works perfectly for me.

## Building the image
Fire up docker (or like in my case boot2docker), navigate to the project and execute the
```
build-image.sh
```
file.

## Starting the image
If you just want the easiest solution, simply start the enterprise manager by
```
run-default-webview-container.sh
```
This image is expected to be connected to a container of ``apm-em`` that will provide the enterprise manager. Furthermore, the image expects that a docker link --link is setup with the logical name being set to "em".
```
docker run -d --name introscope-webview --link introscope-em:em apm-webview
```

## Looking at the logs
As I said I do not like to map the logfiles to my host. docker is great at providing access to them already. What I usually do is to connect to the container with either
```
docker logs em (to see all system.out log output)
```
or even better to simply start a shell
```
docker exec -it webview bash
```
