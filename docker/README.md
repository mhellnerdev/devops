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


├── cms
│   ├── drupal
│   │   ├── docker-compose.yml
│   │   └── readme.md
│   ├── joomla
│   │   └── docker-compose.yml
│   └── wordpress
│       ├── docker-compose.yml
│       └── Dockerfile
├── jenkins-artifactory
│   └── docker-compose.yml
├── nginx-lemp-laravel
│   ├── docker-compose.yml
│   ├── Dockerfile.nginx
│   ├── Dockerfile.old
│   └── urls.txt
├── portainer
│   └── docker-compose.yml
├── README.md
└── ubuntu-base
    ├── docker-compose.yml
    ├── Dockerfile
    ├── Dockerfile.scratch
    ├── hellodocker.sh
    ├── persist-data
    │   └── readme.md
    └── README.md

9 directories, 18 files
