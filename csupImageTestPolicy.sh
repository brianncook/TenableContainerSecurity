#!/bin/bash

####
#
# Description:
#
# Version: .1 Initial Script June 27, 2018
# 
####

ACCESS=$(xmlstarlet sel -t -m '//access' -v . -n < /scm/cs-page/data.xml)
SECRET=$(xmlstarlet sel -t -m '//secret' -v . -n < /scm/cs-page/data.xml)

dockerImages=( "centos:6.7" "centos" "ubuntu:14.04" "ubuntu" "postgres:9.6.9" "alpine:3.2" "alpine:3.4" "postgres:9-alpine" "nginx:1.13" "nginx" "httpd:2.2" "httpd:2.2-alpine" "mongo:3.4" "mongo:3.5" "docker.elastic.co/kibana/kibana:6.2.4" )

if [ ! -d "/scm/results" ]; then
  mkdir /scm/results
fi

for i in "${dockerImages[@]}"
do
  echo "Pull down image $i."
  docker pull $i
  id=$(docker images $i --format "{{.ID}}")
  number=$(docker images $i --format "{{.Tag}}")
  name=$(docker images $i --format "{{.Repository}}")  
  csup --access-key $ACCESS --secret-key $SECRET upload $id -T $number -N base/$name -rp > /scm/results/$name_$tag.txt
  csup --access-key $ACCESS --secret-key $SECRET policy $id
done 
