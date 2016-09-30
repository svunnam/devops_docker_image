########## How To Use Docker Image ###############
##
##  Install docker utility
##  Download docker image: denny/jenkins:latest
##  Boot docker container: docker run -t -d -h jenkins --name my-jenkins --privileged -p 61022:9000 -p 61023:22 -p 61081:28000 -p 61082:28080 denny/jenkins:latest /usr/sbin/sshd -D
##
##     ruby --version
##     gem --version
##     which docker
##     which kitchen
##     which chef-solo
##     source /etc/profile
##     service jenkins start
##      curl -v http://localhost:28080
##
##     service apache2 start
##      curl -v http://localhost:28000/README.txt
##
##     sudo $SONARQUBE_HOME/bin/linux-x86-64/sonar.sh start
##       ps -ef | grep sonar
##       curl -v http://localhost:9000
##       ls -lth /var/lib/jenkins/tool
##################################################

FROM denny/jenkins:v1
MAINTAINER DennyZhang.com <http://dennyzhang.com>

########################################################################################
# TODO: install jenkins jobs by chef deployment

rm -rf /var/cache/*
########################################################################################
