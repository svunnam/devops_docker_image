########## How To Use Docker Image ###############
##
##  Install docker utility
##  Download docker image: docker pull denny/shadowsock:v1
##
##  Start container:
##   docker run -t -d --privileged -h shadowsock --name my-shadowsock -p 6187:6187 denny/shadowsock:v1 /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
##
##   docker exec -it my-shadowsock bash
##     ps -ef | grep shadow
##     # Reload setting
##     supervisorctl reload
##
##     service supervisor status
##     telnet 127.0.0.1 6187
##     # Check log
##     tail -f /var/log/supervisor/shadowsocks-stderr*
##################################################

FROM ubuntu:14.04
MAINTAINER DennyZhang.com <http://dennyzhang.com>

########################################################################################
RUN apt-get -y update && \
    apt-get install -y python-pip python-m2crypto supervisor lsof && \
    pip install shadowsocks && \

# create /etc/shadowsocks.json
# create /etc/supervisor/conf.d/shadowsocks.conf
# autostart supervisord
# vim /etc/rc.local

service supervisor start

supervisorctl reload

# clean up
rm -rf /var/cache/*
rm -rf /tmp/* /var/tmp/*
rm -rf /usr/share/doc && \
apt-get clean && apt-get autoclean
########################################################################################
