#!/bin/bash -e
##-------------------------------------------------------------------
## @copyright 2017 DennyZhang.com
## Licensed under MIT 
##   https://raw.githubusercontent.com/DennyZhang/devops_public/master/LICENSE
##
## File : docker_shellcheck.sh
## Author : Denny <denny@dennyzhang.com>
## Description :
## --
## Created : <2017-05-12>
## Updated: Time-stamp: <2017-05-12 22:49:20>
##-------------------------------------------------------------------
ignore_file=${1?""}
container_name=${2?""}
code_dir=${3?""}
image_name=${4:-"denny/pylint:1.0"}

echo "Generate the ignore file for code check"
echo $pylint_ignore > /tmp/$ignore_file

echo "Start container"
docker stop $container_name; docker rm $container_name; true
docker run -t -d --privileged -v ${code_dir}:/code --name $container_name --entrypoint=/bin/sh $image_name

echo "Copy ignore file"
docker cp /tmp/$ignore_file $container_name:/$ignore_file

echo "Run pylint check"
docker exec -t $container_name python /enforce_pylint_check.py --code_dir /code --check_ignore_file /${ignore_file}

echo "Destroy container"
docker stop $container_name; docker rm $container_name
## File : docker_shellcheck.sh ends
