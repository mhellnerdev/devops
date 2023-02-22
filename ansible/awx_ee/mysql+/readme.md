### Build the venv in dir

python3 -m venv venv

### Activate the venv

. venv/bin/activate

### Install ansible builder

pip install ansible-builder

### Needed to build the dependeny map from requirements.yml

ansible-galaxy install -r requirements.yml

### Build the docker container with verbosity

ansible-builder build --tag mhellnerdev/mysql_supported_ee:latest -v3

# Push to registry

docker push mhellnerdev/mysql_supported_ee:latest
