########## How To Use Docker Image ###############
##
##  Install docker utility
##  Download docker image: docker pull denny/ss:v1
##  Build Image From Dockerfile. docker build -f ss_v1.dockerfile -t denny/ss:v1 --rm=true .
##
##  Start container:
##   docker run -t -d --privileged -h ss --name my-ss -p 6187:6187 denny/ss:v1 /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
##
##   Default password: DamnGFW1234, default server port: 6187
##
##   docker exec -it my-ss bash
##     # Change password
##     sed -i sed -i "s/DamnGFW/DamnFirewall123/g" /etc/shadowsocks.json
##
##     # Reload setting
##     supervisorctl reload
##
##     # Check status
##     ps -ef | grep shadowsock
##
##     service supervisor status
##     telnet 127.0.0.1 6187
##     # Check log
##     tail -f /var/log/supervisor/sss-stderr*
##################################################

FROM ubuntu:14.04
MAINTAINER DennyZhang.com <http://dennyzhang.com>

ARG VPN_PASSWORD="DamnGFW1234"
ARG SERVER_PORT="6187"

########################################################################################
RUN apt-get -y update && \
    apt-get install -y lsof wget telnet tcpdump && \
    apt-get install -y python-pip python-m2crypto supervisor lsof && \
    pip install shadowsocks && \

# Configure shadowsock password
   wget -O /etc/shadowsocks.json \
        https://raw.githubusercontent.com/DennyZhang/devops_docker_image/tag_v2/shadowsock/resource/shadowsocks.json && \
   sed -i "s/DamnGFW/${VPN_PASSWORD}/g" /etc/shadowsocks.json && \
   sed -i "s/6188/${SERVER_PORT}/g" /etc/shadowsocks.json && \

# Use supervisord to start shadowsock
   wget -O /etc/supervisor/conf.d/shadowsocks.conf \
        https://raw.githubusercontent.com/DennyZhang/devops_docker_image/tag_v2/shadowsock/resource/shadowsocks.conf && \

   service supervisor restart && \

# clean up, to make image smaller
   rm -rf /var/cache/* && \
   rm -rf /tmp/* /var/tmp/* && \
   rm -rf /usr/share/doc
########################################################################################
