########## How To Use Docker Image ###############
##
##  Image Name: denny/selenium:v1
##
##  Start container:
##    mkdir -p /tmp/screenshot && chmod 777 /tmp/screenshot
##    docker run -d -p 4444:4444 -v /tmp/screenshot:/tmp/screenshot -h selenium --name selenium denny/selenium:v1
##
##  Run seleinum test
##    docker exec selenium python /home/seluser/selenium_load_page.py --page_url http://www.dennyzhang.com
##
##################################################

# Base image: https://hub.docker.com/r/selenium/standalone-chrome/

FROM selenium/standalone-chrome
MAINTAINER DennyZhang.com <http://dennyzhang.com>

USER root

ADD https://raw.githubusercontent.com/DennyZhang/devops_public/tag_v5/python/selenium_load_page/selenium_load_page.py \
    /home/seluser/selenium_load_page.py

# install selenium python sdk
RUN apt-get -y update && pip install selenium

# Download seleinum page load test scripts

# Verify docker image

# Switch back to normal OS user
USER seluser
