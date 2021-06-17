#!/bin/bash
image='scrna:SM'
name='scSM'
folder='/media/storage/Dropbox/'
port=8897

path="${folder/#\~/$HOME}"
parentdir="$(dirname "$path")"
chmod 755 $parentdir
echo "PATH IS ${path} AND PARENT IS ${parentdir}"
echo "Mounting $path onto the Docker image."
echo "Building image with name ${image}."

docker kill $name
docker build docker-build -f docker-build/DockerfileSM -t $image --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g)
docker rmi $(docker images --filter "dangling=true" -q --no-trunc)

echo "Launching container with name ${name} using port ${port}, attached to volume in path ${path}."
docker run -d --rm --name=$name \
           -v $path:/jupyter/notebooks \
           -p $port:$port -e PORT=$port $image
