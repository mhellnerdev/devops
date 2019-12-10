#! /bin/bash

#INSTALL GRAFANA
# we start the container with a storage volume that not exits yet,
# do not worry, docker creates it for us

# we keep the config file for persistence and later use

docker run -d -p 3000:3000 \
           --name grafana \
           -v /home/mhellner/devops/docker/prometheus-grafana/grafana.ini:/etc/grafana/grafana.ini \
           -v grafana-storage:/var/lib/grafana \
            grafana/grafana
            
#INSTALL PROMETHEUS
# we keep the config file for persistence and later use
 docker run -d -p 9090:9090 \
            --name prometheus \
            -v /home/mhellner/devops/docker/prometheus-grafana/prometheus.yml:/etc/prometheus/prometheus.yml \
            prom/prometheus