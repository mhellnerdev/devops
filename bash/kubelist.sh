#!/bin/bash

if [ "$1" == "namespaces" ]; then
    kubectl get namespaces "${@:2}"
elif [ "$1" == "ingress" ]; then
    kubectl get ingress -A
else
    namespace=$1
    tput setaf 2
    echo ""
    echo "[!] 'kubelist namespaces' to list all namespaces"
    echo "[!] 'kubelist <namespace>' will list the running pods and network services"
    echo "[!] 'kubelist <namespace> -o wide' will provide more detailed output"
    echo "[!] 'kubelist <namespace> pv' will provide information about physical volumes attached"
    echo "[!] 'kubelist ingress' will provide information about the ingress controllers on all namespaces"
    echo ""
    tput sgr0
    kubectl get namespaces -A
    if [ -z "$namespace" ]; then
        read -p "Please enter a namespace: " namespace
    fi
    if kubectl get namespaces | grep -q $namespace; then
        echo "Pods in namespace: $namespace"
        kubectl get pods -n $namespace "${@:2}"
        echo ""
        echo "Services in namespace: $namespace"
        kubectl get services -n $namespace "${@:2}"
        if [ "$2" == "pv" ]; then
            echo ""
            echo "Attached storage in namespace: $namespace"
            kubectl get pv -n $namespace "${@:3}"
        fi
    else
        echo "Invalid namespace. Please provide a valid namespace"
        exit 1
    fi
fi