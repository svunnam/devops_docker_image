########## How To Use Docker Image ###############
##
##  docker image for wordpress blog: http://www.dennyzhang.com
##
##  Install docker utility
##  Download docker image: docker pull denny/blog:v1
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

FROM denny/devubuntu:v1
MAINTAINER DennyZhang.com <http://dennyzhang.com>

########################################################################################
apt-get update
apt-get install -y apache2 php5 libapache2-mod-php5 php5-mysql
apt-get install -y mysql-server

# enable Apache modules
service apache2 restart
a2enmod proxy proxy_http rewrite headers authz_groupfile cgid
service apache2 restart

# checkout Apache vhost
cd /var/www/
git clone https://dennyzhang001@bitbucket.org/dennyzhang001/denny_blog.git
chown www-data:www-data -R /var/www/denny_blog

# create mysql db
service mysql start
mysql -u root -p

CREATE USER blog@localhost IDENTIFIED BY "CHANGEYOURPASSWORD";
create database dennyblog;
GRANT ALL ON dennyblog.* TO blog@localhost;
FLUSH PRIVILEGES;
exit

# inject db from exported mysql file
mysql -ublog -poscBLOG2015 dennyblog < /tmp/mysql-dennyblog.sql
rm -rf /tmp/mysql-dennyblog.sql

# define Apache vhost
vim /etc/apache2/sites-enabled/denny-blog.conf
service apache2 restart

# vhost update
sed -i 's/ServerName www.dennyzhang.com/#ServerName www.dennyzhang.com/g' /etc/apache2/sites-enabled/denny-blog.conf
########################################################################################
