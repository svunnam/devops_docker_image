########## How To Use Docker Image ###############
##
##  Install docker utility
##  Download docker image: docker pull denny/sshd:latest
##  Boot docker container: docker run -t -d -h mytest --name my-test --privileged -p 5022:22 denny/sshd:latest /usr/sbin/sshd -D
##
##################################################

FROM denny/sshd:v1
MAINTAINER DennyZhang.com <denny@dennyzhang.com>

########################################################################################

########################################################################################
