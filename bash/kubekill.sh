#!/bin/bash

# check if any arguments were passed
if [ $# -eq 0 ]; then
    echo "No namespace provided"
    exit 1
fi

# prompt for confirmation
read -p "Are you sure you want to delete all resources in namespace $1? (y/n) " confirm

if [ "$confirm" != "y" ]; then
    echo "Aborting."
    exit 0
fi

# run the kubectl delete command with the namespace argument
# kubectl delete all --all --namespace=$1
kubectl delete namespace $1