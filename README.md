[![Build Status](https://travis-ci.org/DennyZhang/devops_docker_image.svg?branch=master)](https://travis-ci.org/DennyZhang/devops_docker_image) [![LinkedIn](https://www.dennyzhang.com/wp-content/uploads/sns/linkedin.png)](https://www.linkedin.com/in/dennyzhang001) [![Github](https://www.dennyzhang.com/wp-content/uploads/sns/github.png)](https://github.com/DennyZhang) [![Twitter](https://www.dennyzhang.com/wp-content/uploads/sns/twitter.png)](https://twitter.com/dennyzhang001) [![Slack](https://www.dennyzhang.com/wp-content/uploads/sns/slack.png)](https://www.dennyzhang.com/slack)
- File me [tickets](https://github.com/DennyZhang/devops_docker_image/issues) or star [this github repo](https://github.com/DennyZhang/devops_docker_image)

```
########## How To Build Docker Image #############
##
##  Build image from Dockerfile. docker build -t denny/mytest:v1 --rm=true .
##  Run docker intermediate container:
##         docker run -t -d --privileged -h mytest --name my-test -p 5122:22 denny/mytest:v1 /usr/sbin/sshd -D
##         docker run -t -i --privileged -h mytest --name my-test denny/mytest:v1 /bin/bash
##
##  Commit local image:
##    docker commit -m "Initial version" -a "Denny Zhang<contact@dennyzhang.com>" e955748a2634 denny/osc:v1
##    # Get docker user credential first
##    docker login
##    docker push denny/mytest:v1
##    docker history denny/mytest:v1
##
##################################################
```

Test docker image with chef
```
echo "cookbook_path '/root/iamdevops/cookbooks'" > /root/client.rb
echo "{\"run_list\": [\"recipe[jenkins-auth::conf_jenkins]\"], \"os_basic\":{\"enable_firewall\":\"0\"}, \"jenkins_auth\":{\"jobs\":\"BuildRepoCode,UpdateSandbox,UpdateJenkinsItself\"}}" > /root/client.json

echo "{\"run_list\": [\"recipe[autotest-auth::default]\"]}" > /root/client.json
cd /root/test/master/iamdevops/cookbooks
git pull

chef-solo --config /root/client.rb -j /root/client.json
```

Discuss with Denny in [LinkedIn](https://www.linkedin.com/in/dennyzhang001) or [Blog](https://www.dennyzhang.com).

Code is licensed under [MIT License](https://www.dennyzhang.com/wp-content/mit_license.txt).
