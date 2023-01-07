#!/bin/bash

sudo dnf update -y
sudo dnf install epel-release -y
sudo dnf install epel-next-release -y
sudo dnf install vim -y
sudo dnf install htop -y
sudo dnf install tar -y
sudo dnf install git -y
sudo systemctl disable firewalld --now
sudo dnf install open-vm-tools
sudo setenforce 0
sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config && cat /etc/selinux/config
# sudo init 0 
sudo hostnamectl set-hostname awx-stream
sudo vim /etc/hosts
sudo init 6

# install k3s
curl -sfL https://get.k3s.io | sudo bash -
sudo su -
kubectl get nodes
kubectl get pods -A

# install kustomize
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
sudo mv kustomize /usr/local/bin

# setup kustomize
cat <<EOF | tee kustomize.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  # Find the latest tag here: https://github.com/ansible/awx-operator/releases
  - github.com/ansible/awx-operator/config/default?ref=1.1.3

# Set the image tags to match the git version from above
images:
  - name: quay.io/ansible/awx-operator
    newTag: 1.1.3

# Specify a custom namespace in which to install AWX
namespace: awx 
EOF

# Set default namespace to awx. Use if you do not want to keep using -n or --namespace
kubectl config set-context --current --namespace=awx

# See pods all starting, otherwise pass --namespace awx
kubectl get pods -n awx
kubectl get pods -A

# Get logs of awx-operator pod
kubectl logs -f awx-operator-controller-manager-577f6968b5-vqks8

# Create AWX pods yaml
cat <<EOF | tee awx.yaml
---
apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: awx
spec:
  service_type: nodeport
  nodeport_port: 30080 
EOF

# TODO Add '- awx.yaml' in kustomization.yaml to resources line after the github link.

# Run kustomize build again to apply new included awx.yaml file. This step stands up ansible awx on kubernetes.
# This may take a while. Watch logs as it comes up with next command
kustomize build . | kubectl apply -f -

# Watch logs of awx-operator pod
sudo kubectl logs -f awx-operator-controller-manager-577f6968b5-vqks8 -c awx-manager --namespace awx

# Check all pods are up and running
kubectl get pods -n awx
kubectl get pods -A

# Outputs secret password that is needed to login for the first time.
kubectl get secret awx-admin-password -o jsonpath="{.data.password}" --namespace awx | base64 --decode

# get network info about pods. Look for exposed NodePort for awx-service.
# Should be 30080 as defined in the awx.yaml file setup earlier.
# Visit hosts IP address with this port to login to AWX for the first time.
kubectl get svc -A

