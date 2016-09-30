########## How To Use Docker Image ###############
##
##  Install docker utility
##  Download docker image: docker pull denny/ftp:v1
##  Boot docker container: docker run -t -d -h myftp --name my-ftp --privileged -p 40000-40100:40000-40100 -p 21:21 -p 61034:22 denny/ftp:v1 /usr/sbin/sshd -D
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

FROM denny/sshd:v1
MAINTAINER DennyZhang.com <http://dennyzhang.com>

########################################################################################
sudo apt-get update
sudo apt-get install ftp vsftpd

# vim /etc/vsftpd.conf
#     Uncomment the below lines (line no:29 and 33).
#         write_enable=YES
#         local_umask=022
#     Uncomment the below line (line no: 120 ) to prevent access to the other folders outside the Home directory.
#         chroot_local_user=YES
#     and add the following line at the end.
#         allow_writeable_chroot=YES
#
#         pasv_enable=Yes
#         pasv_min_port=40000
#         pasv_max_port=40050
#         pasv_address=<(public ip)>
##################################################
mkdir -p /var/run/vsftpd/empty

sudo useradd -m myftp -s /usr/sbin/nologin
sudo passwd myftp

# Allow login access for nologin shell. Open /etc/shells and add the following line at the end.
# vim /usr/sbin/nologin

# clean up
rm -rf /var/cache/*
rm -rf /tmp/* /var/tmp/*
rm -rf /usr/share/doc && \
apt-get clean && apt-get autoclean
########################################################################################
