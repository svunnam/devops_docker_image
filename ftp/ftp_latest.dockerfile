########## How To Use Docker Image ###############
##
##  Install docker utility
##  Download docker image: docker pull denny/ftp:latest
##  Boot docker container: docker run -t -d -h mytest --name my-test --privileged -p 61031:21 -p 61034:22 denny/ftp:latest /usr/sbin/sshd -D
##
##    ps -ef | grep vsftpd
##    nohup /usr/sbin/vsftpd &
##    lsof -i tcp:21
##    tail /var/log/vsftpd.log
##    ftp 127.0.0.1
##     ftp credential: myftp/XXXX
##################################################

FROM denny/ftp:v1
MAINTAINER DennyZhang.com <denny@dennyzhang.com>

########################################################################################
sudo passwd myftp
########################################################################################
