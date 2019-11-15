#!/bin/bash

docker rm $(docker ps -aq -f 'status=exited')

echo "########################################"
echo "####### Cleaned Containers #############"
echo "########################################"

docker rmi $(docker images -f 'dangling=true' -q)

echo "########################################"
echo "####### Cleaned Dangling Images ########"
echo "########################################"