########## How To Use Docker Image ###############
##
##  Install docker utility
##  Download docker image: docker pull denny/elk:datareport
##  Boot docker container:
##     container_name="elk-aio"
##     docker run -t -d -h mytest --name my-test --privileged -v /root/ -p 5022:22 -p 5601:5601 denny/elk:datareport /usr/sbin/sshd -D
##  Start services:
##     docker start $container_name
##     docker exec $container_name /opt/logstash/bin/logstash -e 'input { stdin { } } output { elasticsearch { host => localhost } }'
##
##################################################

FROM denny/elk:v1
MAINTAINER DennyZhang.com <denny@dennyzhang.com>

########################################################################################
# create logstash setting, to parse /var/log/data_report.log
#    Sample data entry:
     echo "[11/Jul/2016:08:13:45 +0000] mdm-master diskUsed 117314535" >> /var/log/data_report.log
     echo "[11/Jul/2016:09:13:45 +0000] mdm-master diskUsed 117314535" >> /var/log/data_report.log
     echo "[11/Jul/2016:10:13:45 +0000] mdm-master diskUsed 117314535" >> /var/log/data_report.log

     echo "[11/Jul/2016:10:13:45 +0000] staging-index-cf5e90 docsNum 20576163" >> /var/log/data_report.log
     echo "[11/Jul/2016:10:13:45 +0000] master-index-fd1125e docsNum 43" >> /var/log/data_report.log
#
rm -rf /etc/logstash/conf.d/*
cat > /etc/logstash/conf.d/data_report.conf <<EOF
input {                                                                                                                              
  file {                                                                                                                             
    path => "/var/log/data_report.log"                                                                                             
    start_position => beginning                                                                                                      
  }                                                                                                                                  
}                                                                                                                                    
                                                                                                                                     
filter {
    if [path] =~ "data_report" {
        grok {
            match => {"message" => "\[%{HTTPDATE:log_timestamp}\] %{NOTSPACE:item_name} %{NOTSPACE:property_name} %{NOTSPACE:property_value:float}"
            }
       }
       date {
          match => [ "log_timestamp", "dd/MMM/YYYY:MM:mm:ss Z" ]
       }
   }
}

output {
  elasticsearch {
    host => localhost
  }
  stdout { codec => rubydebug }
}
EOF

# Restart logstash
service logstash restart

# Delete saved diagrams and dashboards

# Refresh index

# Inject test data

# Define diagrams and dashboards
########################################################################################
