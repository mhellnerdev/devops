#### Commands
##### Below command will mount local folder to folder inside container. must use absolute pathing. this allows for easy data sharing between conainer and host.
```docker run -v /home/mhellnerdev/devops/docker/ubuntu-base/persist-data:/home/output hellodocker```