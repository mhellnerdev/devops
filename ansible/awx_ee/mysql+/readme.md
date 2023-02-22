### Build the venv in dir

python3 -m venv venv

### Activate the venv

. venv/bin/activate

### Install ansible builder

pip install ansible-builder

### Needed to build the dependeny map from requirements.yml

ansible-galaxy install -r requirements.yml

### Build the docker container

ansible-builder build --tag mhellnerdev/mysql_supported_ee:latest
