#!/bin/sh
FORCE=false
DOCKER_NAME=alpine-sphinx
. $PWD/.env

while [ "$1" != "" ]; do
  if [ $1 = "-f" ]; then 
    FORCE=true
  fi
  shift
done

# if any exist docker container then stop it
if docker ps -a | grep $DOCKER_NAME | grep Up; then
  docker stop $DOCKER_NAME
fi

# if any exists docker container then remove it
if docker ps -a | grep $DOCKER_NAME; then
  docker rm $DOCKER_NAME
fi


# docker image exists and force then remove existing image
if docker images | grep fudyartanto/$DOCKER_NAME && $FORCE; then
  docker rmi fudyartanto/$DOCKER_NAME
fi


# not docker image exists or force then build docker
if ! docker images | grep fudyartanto/$DOCKER_NAME || $FORCE; then
  docker build -t fudyartanto/$DOCKER_NAME .
fi


docker run -tid -p 9306:9306 --name $DOCKER_NAME -v $PWD:/src -e "MYSQL_USER=$MYSQL_USER" -e "MYSQL_PASSWORD=$MYSQL_PASSWORD" -e "MYSQL_HOST=$MYSQL_HOST" fudyartanto/$DOCKER_NAME

