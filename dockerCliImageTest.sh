#!/bin/bash

####
#
# Description:
#
# Requirements: 
#	xmlstartlet & jq: yum install -y epel-release && yum install -y jq xmlstartlet
#	data.xml (Maake sure your api keys are in the file.): https://github.com/brianncook/TenableContainerSecurity/blob/master/data.xml 
#
# Version: .1 Initial Script June 26, 2018
# 
####

ACCESS=$(xmlstarlet sel -t -m '//access' -v . -n < /scm/cs-page/data.xml)
SECRET=$(xmlstarlet sel -t -m '//secret' -v . -n < /scm/cs-page/data.xml)

dockerImages=( "centos:6.7" "centos:latest" "ubuntu:14.04" "ubuntu:latest" "postgres:9.6.9" "alpine:3.2" "alpine:3.4" "postgres:9-alpine" "nginx:1.13" "nginx:latest" "httpd:2.2" "httpd:2.2-alpine" "mongo:3.4" "mongo:3.5" "docker.elastic.co/kibana/kibana:6.2.4" )

if [ ! -d "/scm/results" ]; then
  mkdir -p /scm/results
fi

for i in "${dockerImages[@]}"
do
  echo "Pull down image $i."
  docker pull $i
  number=$(docker images $i --format "{{.Tag}}")
  name=$(docker images $i --format "{{.Repository}}")
  id=$(docker images $i --format "{{.ID}}")
  docker tag $i registry.cloud.tenable.com/base/$i
  docker login -u $ACCESS -p $SECRET registry.cloud.tenable.com
  docker push registry.cloud.tenable.com/base/$i
  curl -H "X-ApiKeys: accessKey=$ACCESS; secretKey=$SECRET" https://cloud.tenable.com/container-security/api/v1/reports/by_image?image_id=$id | jq '.' > /scm/results/$i_dockercli.txt
done
