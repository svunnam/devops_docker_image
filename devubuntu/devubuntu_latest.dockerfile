########## How To Use Docker Image ###############
##
##  Install docker utility
##  Download docker image: docker pull denny/devubuntu:latest
##  Boot docker container: docker run -t -d denny/devubuntu:latest /bin/bash
##
##     ruby --version
##     gem --version
##     gem sources -l
##     python --version
##     java -version
##     chef-solo --version
##################################################

FROM denny/devubuntu:v1
MAINTAINER DennyZhang.com <denny@dennyzhang.com>

########################################################################################
# install docker with 1.11.2
wget -qO- https://get.docker.com/ | sh
apt-get install -y docker-engine=1.11.2-0~trusty
apt-mark hold docker-engine

service docker stop

docker --version | grep 1.11.2
########################################################################################
