This is a code repository for:
 - Automated Provisioning (TerraForm)
 - Application Configuration Management
 - Automated Deployments
 - Monitoring Automation


##### Docker Notes
- docker pull <image name>
- docker run <image name>
- docker run -idt -p 80:80 <image name> 

- docker build -t <tag name> .
- docker exec -it <containter id> /bin/bash

- docker tag <old image> <new image> - useful for when you make changes inside the container