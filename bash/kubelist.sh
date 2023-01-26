#!/bin/bash

if [ "$1" == "namespaces" ]; then
    kubectl get namespaces "${@:2}"
else
    namespace=$1
    if [ -z "$namespace" ]; then
        read -p "Please provide a namespace: " namespace
    fi
    if kubectl get namespaces | grep -q $namespace; then
        echo "Pods in namespace: $namespace"
        kubectl get pods -n $namespace "${@:2}"
        echo ""
        echo "Services in namespace: $namespace"
        kubectl get services -n $namespace "${@:2}"
    else
        echo "Invalid namespace. Please provide a valid namespace"
        exit 1
    fi
fi