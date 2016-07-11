########## How To Use Docker Image ###############
##
##  Install docker utility
##  Download docker image: docker pull denny/elk:v1
##  Boot docker container:
##     container_name="elk-aio"
##     docker run -t -d -h mytest --name my-test --privileged -v /root/ -p 5022:22 -p 5601:5601 -p 9200:9200 denny/elk:v1 /usr/sbin/sshd -D
##  Start services:
##     docker start $container_name
##     docker exec $container_name /opt/logstash/bin/logstash -e 'input { stdin { } } output { elasticsearch { host => localhost } }'
##
##     service elasticsearch start
##     service kibana4 start
##     service nginx start
##     service logstash start
##
##     service elasticsearch status
##     service kibana4 status
##     service nginx status
##     service logstash status
##
##     lsof -i tcp:5601
##     ls -lth /etc/logstash/conf.d
##     tail -f /var/log/logstash/logstash.stdout
##
##################################################

FROM denny/sshd:v1
MAINTAINER DennyZhang.com <denny@dennyzhang.com>

########################################################################################
#  https://www.digitalocean.com/community/tutorials/how-to-install-elasticsearch-logstash-and-kibana-4-on-ubuntu-14-04

# clean up
rm -rf /var/cache/*
rm -rf /tmp/* /var/tmp/*
rm -rf /usr/share/doc && \
apt-get clean && apt-get autoclean
########################################################################################
