########## How To Use Docker Image ###############
##
##  Install docker utility
##  Download docker image: docker pull denny/datareport:v1.0
##  Start container: docker run -t -P -d --name my-test denny/datareport:v1.0 /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
##
##  /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
##  elasticsearch: 2.4.1
##      /usr/share/elasticsearch/bin/elasticsearch --version
##  # logstash: 2.2.4
##      /opt/logstash/bin/logstash --version
##  # kibana: 4.5.0
##      /opt/kibana/bin/kibana --version
##
##  Build Image From Dockerfile. docker build -f Dockerfile_datareport_v1_0 -t denny/datareport:v1.0 --rm=true .
##################################################
# https://hub.docker.com/r/willdurand/elk/~/dockerfile/
# https://www.digitalocean.com/community/tutorials/how-to-install-elasticsearch-logstash-and-kibana-elk-stack-on-ubuntu-14-04
FROM denny/java:v1.0
MAINTAINER Denny <denny@dennyzhang.com>
ARG working_dir=/root/

# Install elk
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && \
    apt-get install --no-install-recommends -y supervisor curl wget && \

# Elasticsearch
    echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" \
         | tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list && \
    echo 'deb http://packages.elastic.co/logstash/2.2/debian stable main' \
         | tee -a /etc/apt/sources.list.d/logstash-2.2.x.list && \
    apt-get -y update && \

    apt-get install --no-install-recommends -y --force-yes elasticsearch && \
    sed -i '/#cluster.name:.*/a cluster.name: logstash' /etc/elasticsearch/elasticsearch.yml && \
    sed -i '/#path.data: \/path\/to\/data/a path.data: /data' /etc/elasticsearch/elasticsearch.yml && \

    wget -O /etc/supervisor/conf.d/elasticsearch.conf \
         https://raw.githubusercontent.com/TOTVS/mdmpublic/master/docker/dockerfile_resource/datareport/elasticsearch.conf && \

    # create elasticsearch data directory
    mkdir /usr/share/elasticsearch/data && \
    chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data && \

# Logstash
    apt-get install --no-install-recommends -y --force-yes logstash && \
    wget -O /etc/supervisor/conf.d/logstash.conf \
         https://raw.githubusercontent.com/TOTVS/mdmpublic/master/docker/dockerfile_resource/datareport/logstash.conf && \

# Logstash plugins
   /opt/logstash/bin/plugin install logstash-filter-translate && \
   wget -O /etc/logstash/conf.d/data_report.conf \
         https://raw.githubusercontent.com/TOTVS/mdmpublic/master/docker/dockerfile_resource/datareport/data_report.conf && \

# Kibana
   curl -s https://download.elasticsearch.org/kibana/kibana/kibana-4.5.0-linux-x64.tar.gz | tar -C /opt -xz && \
   ln -s /opt/kibana-4.5.0-linux-x64 /opt/kibana && \
   wget -O /etc/supervisor/conf.d/kibana.conf \
        https://raw.githubusercontent.com/TOTVS/mdmpublic/master/docker/dockerfile_resource/datareport/kibana.conf && \

# Install useful packages
   apt-get install -y lsof net-tools vim telnet && \

# Shutdown services

# Clean up to make docker image smaller
   apt-get clean && \

# Verify docker image
   /usr/share/elasticsearch/bin/elasticsearch --version | grep 2.4.1 && \
   /opt/kibana/bin/kibana --version | grep 4.5.0
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
