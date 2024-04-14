# Check args
if [ "$#" -lt 1 ]; then
  #echo "usage: ./run.sh DOCKER_REPO"
  #return 1
  echo "Using default: bdi/melodic_amd64:latest"
  DOCKER_REPO=bdi/melodic_amd64:latest
else
  DOCKER_REPO=$1
fi

if [ "$#" -eq 2 ]; then
  CONTAINER_NAME=$2
fi

##################################################################################

WORKSPACE_DIR=${HOME}/Development/
if [ ! -d $WORKSPACE_DIR ]; then
    mkdir -p $WORKSPACE_DIR
fi
echo "Container name:$CONTAINER_NAME WORSPACE DIR:$WORKSPACE_DIR"



echo "Starting Container: ${CONTAINER_NAME} with REPO: $DOCKER_REPO"

if [ "$(docker ps -aq -f name=${CONTAINER_NAME})" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=${CONTAINER_NAME})" ]; then
        # cleanup
        docker start ${CONTAINER_NAME}
    fi
    if [ -z "$CMD" ]; then
        docker exec -it  ${CONTAINER_NAME} bash
    else
        docker exec -it  ${CONTAINER_NAME} bash -c "$CMD"
    fi
else




#xhost +si:localuser:root
sudo xhost +
EXTERNAL_DRIVE="/media/liangchuan/"
docker run \
	-it \
	--gpus all \
	--rm \
	--net=host \
	--privileged \
	--device=/dev/dri \
	--group-add video \
	--shm-size 24G \
	-p 8888:8888 \
	--volume=/tmp/.X11-unix:/tmp/.X11-unix  \
	-v $HOME/Development:/home/$CONTAINER_USER/Development \
        -v $EXTERNAL_DRIVE:/root/media:rw \
	-w /home/$CONTAINER_USER/Development  \
	--env="DISPLAY=$DISPLAY" \
	--name $CONTAINER_NAME $DOCKER_REPO /bin/bash 

fi
