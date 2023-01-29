#!/bin/bash

# Setup SSH key login
mkdir ~/.ssh
chmod 700 ~/.ssh

# cat pub key into authorized_keys
cat <<EOF | tee ~/.ssh/authorized_keys
<KEY_HERE>
EOF

# Set correct permissions for sshd
chmod 600 ~/.ssh/authorized_keys

# Turn off password authentication
sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config && sudo cat /etc/ssh/sshd_config
sudo systemctl restart sshd && sudo systemctl status sshd

# Package Installs
sudo dnf update -y
sudo dnf install epel-release -y
sudo dnf install epel-next-release -y
sudo dnf install vim -y
sudo dnf install htop -y
sudo dnf install tar -y
sudo dnf install git -y
sudo dnf install wget -y
sudo dnf install net-tools -y
sudo dnf install nc -y
sudo dnf install open-vm-tools -y
sudo systemctl disable firewalld --now
sudo setenforce 0
sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config && cat /etc/selinux/config
sudo vim /etc/hosts
sudo init 6

# install k3s
curl -sfL https://get.k3s.io | sudo bash -
# Take ownership of k3s config yaml to prevent need for sudo
sudo chown $USER:$USER /etc/rancher/k3s/k3s.yaml
kubectl version
# sudo su -
kubectl get nodes
kubectl get pods -A

# Get token for adding more nodes
cat /var/lib/rancher/k3s/server/node-token

# Command to run on worker nodes to join to cluster
curl -sfL https://get.k3s.io | K3S_TOKEN="K10500459cbacd1506d342cfbcc9ac464797e157d4bc5d3d6d6cc47eae53fd38d03::server:1b85cd7d5eb03c414a232cbfe29bf101" K3S_URL="https://k3s-1.circlelabs.home:6443" K3S_NODE_NAME="k3s-2.circlelabs.home" bash -


# install kustomize
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
sudo mv kustomize /usr/local/bin

