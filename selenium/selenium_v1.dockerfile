########## How To Use Docker Image ###############
##
##  Image Name: denny/selenium:v1
##  Start container:
##    mkdir -p /tmp/screenshot && chmod 777 /tmp/screenshot
##    docker run -d -p 4444:4444 -v /tmp/screenshot:/tmp/screenshot -h selenium --name selenium denny/selenium:v1
##
##################################################

# Base image: https://hub.docker.com/r/selenium/standalone-chrome/

FROM selenium/standalone-chrome
MAINTAINER DennyZhang.com <http://dennyzhang.com>
