FROM ubuntu:18.04

RUN mkdir /app

COPY urls.txt /app

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install nginx -y


CMD cat /app/urls.txt
