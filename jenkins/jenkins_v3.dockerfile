########## How To Use Docker Image ###############
##
##  Install docker utility
##  Download docker image: denny/jenkins:v3
##  Boot docker container: docker run -t -d -h jenkins --name my-jenkins --privileged -p 18080:18080 -p 18000:80 -p 9000:9000 denny/jenkins:v3 /bin/bash
##
##  Build Image From Dockerfile. docker build -f jenkins_v3.dockerfile -t denny/jenkins:v3 --rm=true .
##
##   18080(Jenkins), 18000(Apache), 9000(sonar)
##
##     ruby --version
##     gem --version
##     gem sources -l
##     head `which gem` | grep ruby
##     head `which bundler` | grep ruby
##     which docker
##     which kitchen
##     which chef-solo
##     source /etc/profile
##     service jenkins start
##      curl -v http://localhost:18080
##
##     service apache2 start
##      curl -v http://localhost:80/
##
##     source /etc/profile
##     sudo $SONARQUBE_HOME/bin/linux-x86-64/sonar.sh start
##       ps -ef | grep sonar
##       curl -v http://localhost:9000
##       ls -lth /var/lib/jenkins/tool
##
##     Built-in jenkins user: dennyzhang/DevOpsChangeMe1 devops.consultant@dennyzhang.com
##################################################

FROM denny/jenkins:v2
ARG jenkins_port="18080"
ARG jenkins_version="2.19"
ARG jenkins_username="chefadmin"
ARG jenkins_passwd="ChangeMe123"

RUN service jenkins start && service apache2 start && \
# Install jenkins jobs
    git clone git@github.com:DennyZhang/devops_jenkins.git && \

########################################################################################
# Verify status
    dpkg -l jenkins | grep "$jenkins_version" && \
    service jenkins status | grep "is running with" && \
    sudo -u jenkins lsof -i tcp:$jenkins_port && \
    java -jar /tmp/jenkins-cli.jar -s http://localhost:18080/ list-jobs && \
    lsof -i tcp:80 && \
    ruby --version | grep "2\.2\.5" && \
    gem list bundle | grep "0\.0\.1" && \
    rubocop --version | grep "0\.44\.1" && \
    foodcritic --version | grep "8\.0\.0" && \
    shellcheck --version | grep "0\.4\.4" && \

# Stop services
   service jenkins stop && \
   service apache2 stop && \

# clean files to make image smaller
   rm -rf /var/run/jenkins/jenkins.pid && \
   rm -rf /tmp/*
   
CMD ["/bin/bash"]
########################################################################################
