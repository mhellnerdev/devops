#!/bin/bash

sudo dnf update -y
sudo dnf install epel-release -y
sudo dnf install epel-next-release -y
sudo dnf install vim -y
sudo dnf install htop -y
sudo systemctl disable firewalld --now
sudo setenforce 0
sudo sed -i 's/SELINUX=enforced/SELINUX=disabled/g' /etc/selinux/config
# sudo init 0 
sudo hostnamectl set-hostname awx-stream
vim /etc/hosts
sudo init 6

# install k3s
curl -sfL https://get.k3s.io | sudo bash -
sudo su -
kubectl get nodes

# Ingest yaml file that builds awx-operator pods
kubectl apply -f https://raw.githubusercontent.com/ansible/awx-operator/0.13.0/deploy/awx-operator.yaml

kubectl get pods -A

# Get logs of awx-operator pod
kubectl logs -f awx-operator-xxxxxxxxxxx

# Create AWX config
cat <<EOF | sudo tee awx.yaml
---
apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: awx
spec:
  service_type: nodeport
  ingress_type: none
  hostname: awx-stream.circlelabs.home  
EOF

# Ingest awx.yaml config. This step stands up ansible.
kubectl apply -f awx.yaml

# Get logs of awx-operator pod
kubectl logs -f awx-operator-xxxxxxxxxxx

# check all pods are up and running
kubectl get pods -A

# get network info about pods
kubectl get svc

