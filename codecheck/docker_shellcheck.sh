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
## Updated: Time-stamp: <2017-05-12 23:02:28>
##-------------------------------------------------------------------
code_dir=${1?""}
container_name=${2?""}
image_name=${3:-"denny/pylint:1.0"}
ignore_file_list=${4-""}

current_filename=$(basename "$0")
ignore_file="${current_filename%.sh}_$$"
check_filename="/enforce_pylint_check.py"

function remove_container() {
    container_name=${1?}
    if docker ps -a | grep "$container_name" 1>/dev/null 2>&1; then
        echo "Destroy container: $container_name"
        docker stop "$container_name"; docker rm "$container_name"
    fi
}

function shell_exit() {
    errcode=$?
    if [ $errcode -eq 0 ]; then
        echo "Test has passed."
    else
        echo "ERROR: Test has failed."
    fi

    echo "Remove tmp file: $ignore_file"
    rm -rf "$ignore_file"

    remove_container "$container_name"
    exit $errcode
}

################################################################################
trap shell_exit SIGHUP SIGINT SIGTERM 0

echo "Generate the ignore file for code check"
echo "$ignore_file_list" > "/tmp/$ignore_file"

echo "Start container"
remove_container "$container_name"
docker run -t -d --privileged -v "${code_dir}:/code" --name "$container_name" --entrypoint=/bin/sh "$image_name"

echo "Copy ignore file"
docker cp "/tmp/$ignore_file" "$container_name:/$ignore_file"

echo "Run code check"
docker exec -t "$container_name" python "$check_filename" --code_dir /code --check_ignore_file "/${ignore_file}"
## File : docker_shellcheck.sh ends
