########## How To Use Docker Image ###############
##
##  Install docker utility
##  Download docker image: docker pull denny/datareport:v1.0
##  Start container: docker run -t -P -d --name my-test denny/datareport:v1.0 /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
##
##  /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
##
##  Build Image From Dockerfile. docker build -f Dockerfile_datareport_v1_0 -t denny/datareport:v1.0 --rm=true .
##################################################
# https://hub.docker.com/r/willdurand/elk/~/dockerfile/
# https://www.digitalocean.com/community/tutorials/how-to-install-elasticsearch-logstash-and-kibana-elk-stack-on-ubuntu-14-04
FROM denny/java:v1.0
MAINTAINER Denny <denny@dennyzhang.com>
ARG working_dir=/root/

ARG LOGSTASH_VERSION=2.4.0
ARG ELASTICSEARCH_VERSION=2.4.1
ARG KIBANA_VERSION=4.6.1

# Install elk
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && \
    apt-get install --no-install-recommends -y supervisor curl wget unzip && \
    apt-get install --no-install-recommends -y lsof net-tools vim telnet && \

# Elasticsearch
    wget -O /opt/elasticsearch-2.4.1.zip https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/zip/elasticsearch/2.4.1/elasticsearch-2.4.1.zip && \
    cd /opt && \unzip elasticsearch-2.4.1.zip && \
    ln -s /opt/elasticsearch-2.4.1 /opt/elasticsearch && \
    # create elasticsearch data directory
    mkdir /usr/share/elasticsearch/data && \
    chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data && \

# Kibana
   wget -O /opt/kibana-4.0.1-linux-x64.tar.gz https://download.elastic.co/kibana/kibana/kibana-4.0.1-linux-x64.tar.gz && \
   cd /opt/ && tar -xf kibana-4.0.1-linux-x64.tar.gz && \
   ln -s /opt/kibana-4.0.1-linux-x64 /opt/kibana && \

# Logstash
   wget -O /opt/logstash-2.4.0.zip https://download.elastic.co/logstash/logstash/logstash-2.4.0.zip && \
   cd /opt/ && unzip logstash-2.4.0.zip && \
   ln -s /opt/logstash-2.4.0 /opt/logstash && \

# Download logstash conf file
   wget -O /etc/supervisor/conf.d/kibana.conf \
        https://raw.githubusercontent.com/TOTVS/mdmpublic/master/docker/dockerfile_resource/datareport/kibana.conf && \

# Start services through supervisord
   wget -O /etc/supervisor/conf.d/kibana.conf \
        https://raw.githubusercontent.com/TOTVS/mdmpublic/master/docker/dockerfile_resource/datareport/kibana.conf && \

# Shutdown services

# Clean up to make docker image smaller
   apt-get clean && \

# Verify docker image
   /opt/logstash/bin/logstash --version --version | grep ${LOGSTASH_VERSION} && \
   /usr/share/elasticsearch/bin/elasticsearch --version | grep ${ELASTICSEARCH_VERSION} && \
   /opt/kibana/bin/kibana --version | grep ${KIBANA_VERSION}
   # TDOO:
   # # start service and check status
   # service supervisor start || true && \
   # sleep 5 && sudo -u elasticsearch lsof -i tcp:9200 && \
   # sleep 5 && lsof -i tcp:5601 && \
   # service supervisor stop && sleep 5

EXPOSE 5601

ENV PATH /opt/logstash/bin:$PATH
ENV JAVA_HOME /opt/jdk/jre
ENV PATH $PATH:$JAVA_HOME/bin

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf" ]
########################################################################################
