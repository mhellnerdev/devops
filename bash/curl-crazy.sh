#!/bin/bash

count=0
target=""

while getopts ":n:t:" opt; do
  case $opt in
    n)
      count=$OPTARG
      ;;
    t)
      target=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      echo "Usage: $(basename $0) [-n count] [-t target]"
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      echo "Usage: $(basename $0) [-n count] [-t target]"
      exit 1
      ;;
  esac
done

if [[ $count -eq 0 || -z $target ]]; then
  echo "Usage: $(basename $0) [-n count] [-t target]"
  exit 1
fi

for i in $(seq $count); do
    if curl -sSf $target >/dev/null; then
        printf "\rGoing CRAZY with the curls. %d completed." $i
    else
        http_code=$(curl -sSf -w "%{http_code}" $target -o /dev/null)
        echo -e "\nCan't connect to $target. Status code: $http_code"
        exit 1
    fi
done

echo -e "\nThe curls were crazy! You curled $count times!"