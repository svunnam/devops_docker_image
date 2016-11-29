# -*- coding: utf-8 -*-
#!/usr/bin/python
##-------------------------------------------------------------------
## File : build_image.py
## Author : Denny <denny@dennyzhang.com>
## Description :
## --
## Created : <2016-04-24>
## Updated: Time-stamp: <2016-11-29 20:36:40>
##-------------------------------------------------------------------
import argparse, os
import subprocess, sys

DOCKER_LIST_FILE = "/tmp/docker_env.sh"

# Each dockerfile should have below line, which helps to get docker image name
IMAGE_NAME_MARKER = "##  Image Name:"

PREFIX_KEY_MSG = "\n============"
FAILED_BUILD_LIST = []
def get_dockerfile_list(docker_list_file):
    docker_list = []
    with open(docker_list_file, 'r') as list_file:
        for row in list_file:
            row = row.strip()
            if row.startswith("#"):
                continue
            else:
                docker_list.append(row)

    if len(docker_list) == 0:
        print "%s ERROR: Please make sure DOCKER_LIST is properly set." \
            % (PREFIX_KEY_MSG)
        sys.exit(1)
    return docker_list

def build_docker_image(docker_file, image_name):
    dir_path = os.path.dirname(docker_file)
    os.chdir(dir_path)

    command = "docker build -f %s -t %s --rm=true ." % (docker_file, image_name)
    print "%s Run: %s" % (PREFIX_KEY_MSG, command)
    p = subprocess.Popen(command, shell=True, stderr=subprocess.PIPE)
    while True:
        out = p.stderr.read(1)
        if out == '' and p.poll() != None:
            break
        if out != '':
            sys.stdout.write(out)
            sys.stdout.flush()

    if p.returncode != 0:
        print "%s ERROR to build: %s" % (PREFIX_KEY_MSG, docker_file)
        FAILED_BUILD_LIST.append(docker_file)

def get_image_name_by_fname(docker_file):
    # Dockerfile contains: ##  Image Name: denny/java:v1.0
    image_name = ""
    if os.path.exists(docker_file) is False:
        print "%s ERROR: file doesn't exist" % (docker_file)
        sys.exit(1)

    with open(docker_file, 'r') as f:
        for row in f:
            if IMAGE_NAME_MARKER in row:
                image_name = row.replace(IMAGE_NAME_MARKER, "").strip()
                break

    # image_name
    if image_name == "":
        raise Exception("Wrong Dockerfile: No %s is found in %s" \
                        % (IMAGE_NAME_MARKER, docker_file))

    return image_name

if __name__ == '__main__':
    # Get docker file list
    docker_file_list = get_dockerfile_list(DOCKER_LIST_FILE)

    # Build all docker images one by one
    for docker_file in docker_file_list:
        image_name = get_image_name_by_fname(docker_file)
        build_docker_image(docker_file, image_name)

    if len(FAILED_BUILD_LIST) != 0:
        print "%s ERROR: below docker build fails: %s" % \
            (PREFIX_KEY_MSG, str(FAILED_BUILD_LIST))
        sys.exit(1)
 ## File : build_image.py ends
