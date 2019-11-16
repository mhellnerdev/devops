#### Docker Notes
##### Commands
- docker pull image name
- docker run image name
- docker run -idt -p 80:80 image name

- docker build -t tag name .
- docker exec -it containter id> /bin/bash
- docker exec -u root -it container_id /bin/bash
- docker run --name=nginx -d -v ~/nginxlogs:/var/log/nginx -p 5000:80 nginx - example for bindmounting a volume. needs absolute pathing

- Avoid below workflow in most cases
- docker tag old image new image - useful for when you make changes inside the container
- docker commit - commits changes to new tag.