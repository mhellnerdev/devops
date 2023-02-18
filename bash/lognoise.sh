#!/bin/bash

# Default number of log messages
num_logs=10

# Parse command-line arguments
while getopts "n:" opt; do
  case ${opt} in
    n )
      num_logs=$OPTARG
      ;;
    \? )
      echo "Usage: $0 [-n num_logs]"
      exit 1
      ;;
  esac
done

# Generate log messages
for ((i=1; i<=$num_logs; i++)); do
  msg=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
  logger $msg
  sleep 1
done