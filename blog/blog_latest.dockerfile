########## How To Use Docker Image ###############
##
##  Install docker utility
##  Download docker image: docker pull denny/blog:latest
##  Boot docker container: docker run -t -d -h blog --name my-blog -p 58080:80 denny/blog:v1 /usr/sbin/sshd -D
##
##  sed -i 's/blogcn1.dennyzhang.com:80/blogcn.dennyzhang.com:58080/g' /root/mysql-dennyblog.sql
##  mysql -ublog -poscBLOG2015 dennyblog < /root/mysql-dennyblog.sql
##
##  service mysql start
##  service apache2 start
##
##  http://$server_ip:58080
##################################################

FROM denny/blog:v1
MAINTAINER DennyZhang.com <http://dennyzhang.com>

########################################################################################
sed -i 's/blogcn1.dennyzhang.com/blog.dennyzhang.com/g' /root/mysql-dennyblog.sql

mysql -ublog -poscBLOG2015 dennyblog < /root/mysql-dennyblog.sql
########################################################################################
