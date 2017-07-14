########## How To Use Docker Image ###############
##
##  Install docker utility
##  Download docker image: docker pull denny/httpd:v1
##  Build docker image: docker build -f Dockerfile -t denny/httpd:v1 --rm=true .
##  Boot docker container:
##
##################################################

# Base image: https://hub.docker.com/_/php/
FROM php:5-apache
MAINTAINER DennyZhang.com <http://dennyzhang.com>

RUN apt-get -y update && \
    apt-get install -y --no-install-recommends lsof vim curl && \
    apt-get install -y --no-install-recommends apache2.2-common && \

# Verify image
    which a2enmod && apachectl -v | grep "2.4"
########################################################################################
