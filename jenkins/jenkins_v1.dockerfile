########## How To Use Docker Image ###############
##
##  Install docker utility
##  Download docker image: denny/jenkins:v1
##  Boot docker container: docker run -t -d -h jenkins --name my-jenkins --privileged -p 61022:9000 -p 61023:22 -p 61081:28000 -p 61082:28080 denny/jenkins:v1 /usr/sbin/sshd -D
##
##   9000 port: Sonar, 22: sshd, 28080: Jenkins, 28080: Apache
##
##     ruby --version
##     gem --version
##     gem sources -l
##     head `which gem` | grep ruby
##     head `which bundler` | grep ruby
##     which docker
##     which kitchen
##     which chef-solo
##     source /etc/profile
##     service jenkins start
##      curl -v http://localhost:28080
##
##     service apache2 start
##      curl -v http://localhost:28000/README.txt
##
##     source /etc/profile
##     sudo $SONARQUBE_HOME/bin/linux-x86-64/sonar.sh start
##       ps -ef | grep sonar
##       curl -v http://localhost:9000
##       ls -lth /var/lib/jenkins/tool
##
##     Built-in jenkins user: dennyzhang/DevOpsChangeMe1 devops.consultant@dennyzhang.com
##################################################

FROM denny/sshd:v1
MAINTAINER DennyZhang.com <denny@dennyzhang.com>

########################################################################################
# install kitchen
cd /tmp/
wget https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.4.0-1_amd64.deb
dpkg -i chefdk_0.4.0-1_amd64.deb
rm -rf /tmp/chefdk_0.4.0-1_amd64.deb

apt-get install -y git unzip zip bc

# install docker
curl -sSL https://get.docker.com/ | sudo sh

# install ruby2 (install ruby 2.2, before install kitchen gem)
sudo apt-get -y update
sudo apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev
cd /tmp
wget http://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.1.tar.gz
tar -xvzf ruby-2.2.1.tar.gz
cd ruby-2.2.1
./configure --prefix=/usr/local
make
make install
ruby --version
rm -rf /tmp/ruby-2.2.1*

# remove old gem and ruby: /usr/bin/gem* /usr/bin/ruby*

# install bundler and gems for kitchen
gem install bundler

cat > /tmp/Gemfile <<EOF
source 'https://rubygems.org'

gem 'test-kitchen', '= 1.4.1'
gem 'kitchen-docker', '= 2.1.0'

gem 'kitchen-digitalocean'

gem 'berkshelf'
gem 'docker'

gem 'busser'
gem 'serverspec', '>= 1.6'

gem 'chefspec',   '~> 4.1.0'
gem 'foodcritic', '~> 4.0.0'
gem 'rubocop',    '~> 0.28.0'
EOF
cd /tmp && bundle install

# install snar for code quality: http://www.sonarsource.org
cat > /etc/profile.d/sonar.sh <<EOF
export SONARQUBE_HOME=/var/lib/jenkins/tool/sonarqube-4.5.6
export SONAR_RUNNER_HOME=/var/lib/jenkins/tool/sonar-scanner-2.5
export PATH=\$PATH:\$SONARQUBE_HOME/bin/linux-x86-64:\$SONAR_RUNNER_HOME/bin
EOF

chmod o+x /etc/profile.d/sonar.sh
source /etc/profile

su jenkins
source /etc/profile
which sonar.sh
mkdir -p /var/lib/jenkins/tool
cd /var/lib/jenkins/tool
wget https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-2.5.zip
unzip sonar-scanner-2.5.zip && rm -rf sonar-scanner-2.5.zip
wget https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-4.5.6.zip
unzip sonarqube-4.5.6.zip && rm -rf sonarqube-4.5.6.zip

source /etc/profile

# Manually install jenkins plugins: timestamp, git client, git, slack, bearychat

# reconfigure timestamper format to use: '<b>'yyyy-MM-dd HH:mm:ss'</b> '

# Add Demo view and built-in jenkins jobs

# configure jenkins system to have 4 executors

# enforce jenkins users authentication

# set locale to UTF-8
locale-gen --lang en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_CTYPE="en_US.UTF-8"

# change locale
cat > /etc/profile.d/locale.sh << EOF
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
EOF

# change locale
cat > /var/lib/jenkins/.bashrc <<EOF
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
EOF
chown jenkins:jenkins /var/lib/jenkins/.bashrc

# install shellcheck for code quality check for bash
# https://github.com/koalaman/shellcheck/issues/439
sudo apt-get install cabal-install
cabal update
cabal install shellcheck

# TODO: configure jenkins authentication: only login user can do anything

# remove sensitive data: /var/lib/jenkins/.ssh/git_deploy_key_id_rsa

# empty /var/lib/jenkins/.ssh/known_hosts

# change ruby gem sources
gem sources -a https://ruby.taobao.org/ && \
gem sources -r https://rubygems.org/ && \
gem sources -r http://rubygems.org/

# pylint
apt-get install -y --force-yes python-dev
pip install pylint flask

# TODO: install jenkins jobs by chef deployment

# Install Jenkins 2.0
http://devopscube.com/install-configure-jenkins-2-0/

# TODO: Persist setting of Jenkins Views

# clean up
rm -rf /tmp/* /var/tmp/*
rm -rf /usr/share/doc && \
apt-get clean && apt-get autoclean
########################################################################################
