#! /bin/bash

git config --global user.email "mhellnerdev@gmail.com"
git config --global user.name "mhellnerdev"

ssh-keygen -t ed25519 -f ~/.ssh/github -C "mhellnerdev@gmail.com" 

echo 'eval $(ssh-agent -s) > /dev/null' >> ~/.bashrc
echo 'ssh-add ~/.ssh/github 2> /dev/null' >> ~/.bashrc