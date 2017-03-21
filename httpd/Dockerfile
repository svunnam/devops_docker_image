########## How To Use Docker Image ###############
##
##  Install docker utility
##  Download docker image: docker pull denny/httpd:v1
##  Build docker image: docker build -f Dockerfile -t denny/httpd:v1 --rm=true .
##  Boot docker container:
##
##################################################

# Base image: https://hub.docker.com/_/httpd/
FROM httpd:2.4
MAINTAINER DennyZhang.com <http://dennyzhang.com>

RUN apt-get -y update && \
    apt-get install -y --no-install-recommends lsof vim curl

########################################################################################
