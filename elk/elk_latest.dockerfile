########## How To Use Docker Image ###############
##
##  Install docker utility
##  Download docker image: docker pull denny/elk:latest
##  Boot docker container:
##     container_name="elk-aio"
##     docker run -t -d -h mytest --name my-test --privileged -v /root/ -p 5022:22 -p 5601:5601 -p 9200:9200 -p 5000:5000 denny/elk:latest /usr/sbin/sshd -D
##  Start services:
##     docker start $container_name
##     docker exec $container_name /opt/logstash/bin/logstash -e 'input { stdin { } } output { elasticsearch { host => localhost } }'
##
##################################################

FROM denny/elk:v1
MAINTAINER DennyZhang.com <denny@dennyzhang.com>

########################################################################################

########################################################################################
