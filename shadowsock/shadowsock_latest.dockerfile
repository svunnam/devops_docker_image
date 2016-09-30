########## How To Use Docker Image ###############
##
##  Install docker utility
##  Download docker image: docker pull denny/shadowsock:latest
##
##  Start container:
##   docker run -t -d --privileged -h shadowsock --name my-shadowsock -p 6187:6187 -p 6188:22 denny/shadowsock:latest /usr/sbin/sshd -D
##
##   docker exec -it my-shadowsock bash
##     ps -ef | grep shadow
##     service supervisor start
##     supervisorctl reload
##
##     service supervisor status
##     telnet 127.0.0.1 6187
##     tail -f /var/log/supervisor/shadowsocks-stderr*
##################################################

FROM denny/shadowsock:v1
MAINTAINER DennyZhang.com <http://dennyzhang.com>

########################################################################################

########################################################################################
