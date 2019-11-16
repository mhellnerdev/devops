FROM ubuntu:18.04

COPY hellodocker.sh /home
COPY install.sh /home

RUN mkdir /home/output

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install tree

CMD sh /home/install.sh > /home/output/log.md && cat /home/output/log.md
