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

# Install k3s as a multimaster setup, with etcd
curl -sfL https://get.k3s.io | sh -s server --cluster-init

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

# Command to run on multi master nodes to join to cluster
curl -sfL https://get.k3s.io | K3S_TOKEN="K107e538f1143c307b8e48e2feaef15395790285923f173833b1098d3fa972e8dda::server:fdb7f85deb605aac6e9cd9326a62a8b5" K3S_URL="https://k3s-1.circlelabs.home:6443" K3S_NODE_NAME="k3s-x.circlelabs.home" sh -s - server --server "https://k3s-1.circlelabs.home:6443"

# Command to run on worker nodes to join to cluster
curl -sfL https://get.k3s.io | K3S_TOKEN="K107e538f1143c307b8e48e2feaef15395790285923f173833b1098d3fa972e8dda::server:fdb7f85deb605aac6e9cd9326a62a8b5" K3S_URL="https://k3s-1.circlelabs.home:6443" K3S_NODE_NAME="k3s-x.circlelabs.home" bash -






# install kustomize
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
sudo mv kustomize /usr/local/bin

