#!/bin/bash

echo This will build a local laravel environment with sail and docker.
echo What is the name of your Laravel project?

read projectname

curl -s https://laravel.build/$projectname | bash
cd $projectname/ && ./vendor/bin/sail up -d
sleep 3
./vendor/bin/sail down
sleep 3
./vendor/bin/sail up -d
sleep 5
./vendor/bin/sail artisan migrate
