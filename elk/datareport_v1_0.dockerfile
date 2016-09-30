########## How To Use Docker Image ###############
##
##  Install docker utility
##  Download docker image: docker pull denny/datareport:v1.0
##  Start container: docker run -t -P -d --name my-test denny/datareport:v1.0 /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
##
##  /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
##
##  Build Image From Dockerfile. docker build -f datareport_v1_0.dockerfile -t denny/datareport:v1.0 --rm=true .
##################################################
# https://github.com/DennyZhang/devops_docker_image/blob/master/java/java_v1_0.dockerfile
# https://www.digitalocean.com/community/tutorials/how-to-install-elasticsearch-logstash-and-kibana-elk-stack-on-ubuntu-14-04
FROM denny/java:v1.0
MAINTAINER Denny <http://dennyzhang.com>

ARG LOGSTASH_VERSION=2.4.0
ARG ELASTICSEARCH_VERSION=2.4.1
ARG KIBANA_VERSION=4.6.1

# Install elk
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && \
    apt-get install --no-install-recommends -y supervisor curl wget unzip && \
    apt-get install --no-install-recommends -y lsof net-tools vim telnet && \

# Elasticsearch
    wget -O /opt/elasticsearch-${ELASTICSEARCH_VERSION}.zip https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/zip/elasticsearch/${ELASTICSEARCH_VERSION}/elasticsearch-${ELASTICSEARCH_VERSION}.zip && \
    cd /opt && \unzip elasticsearch-${ELASTICSEARCH_VERSION}.zip && \
    ln -s /opt/elasticsearch-${ELASTICSEARCH_VERSION} /opt/elasticsearch && \
    useradd elasticsearch
    # create elasticsearch data directory
    mkdir -p /opt/elasticsearch/data /var/run/elasticsearch && \
    chown -R elasticsearch:elasticsearch /opt/elasticsearch/data /var/run/elasticsearch && \

# Kibana
   wget -O /opt/kibana-${KIBANA_VERSION}-linux-x64.tar.gz https://download.elastic.co/kibana/kibana/kibana-${KIBANA_VERSION}-linux-x64.tar.gz && \
   cd /opt/ && tar -xf kibana-${KIBANA_VERSION}-linux-x64.tar.gz && \
   ln -s /opt/kibana-${KIBANA_VERSION}-linux-x64 /opt/kibana && \

# Logstash
   wget -O /opt/logstash-${LOGSTASH_VERSION}.zip https://download.elastic.co/logstash/logstash/logstash-${LOGSTASH_VERSION}.zip && \
   cd /opt/ && unzip logstash-${LOGSTASH_VERSION}.zip && \
   ln -s /opt/logstash-${LOGSTASH_VERSION} /opt/logstash && \

# Download logstash conf file
   wget -O /opt/logstash/data_report.conf \
        https://github.com/DennyZhang/devops_docker_image/raw/master/dockerfile_resource/datareport/data_report.conf && \

# Start services through supervisord
   wget -O /etc/supervisor/conf.d/elasticsearch.conf \
        https://raw.githubusercontent.com/TOTVS/mdmpublic/master/docker/dockerfile_resource/datareport/elasticsearch.conf && \
   wget -O /etc/supervisor/conf.d/kibana.conf \
        https://raw.githubusercontent.com/TOTVS/mdmpublic/master/docker/dockerfile_resource/datareport/kibana.conf && \
   wget -O /etc/supervisor/conf.d/logstash.conf \
        https://raw.githubusercontent.com/TOTVS/mdmpublic/master/docker/dockerfile_resource/datareport/logstash.conf && \

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
