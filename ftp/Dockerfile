########## How To Use Docker Image ###############
##
##  Install docker utility
##  Download docker image: docker pull denny/proftproftpd:v1
##  Build docker image: docker build -f Dockerfile -t denny/proftproftpd:v1 --rm=true .
##  Boot docker container:
##
##    Change pasv_address to correct ip address
##    ps -ef | grep vsftpd
##    nohup /usr/sbin/vsftpd &
##    lsof -i tcp:21
##    tail /var/log/vsftpd.log
##    ls -lth /home/myftp
##    cat /etc/vsftpd.conf
##    ftp 127.0.0.1
##     ftp credential: myftp/XXXX
##    ps -ef | grep cron
##    crontab -l
##    0 0 1 * * find /home/myftp -mtime +30 -and -not -type d -delete
##################################################

# Base image: https://hub.docker.com/r/bluefoxicy/proftpd/~/dockerfile/
FROM bluefoxicy/proftpd:latest
MAINTAINER DennyZhang.com <http://dennyzhang.com>

########################################################################################
