#!/bin/sh

dockerImages=( {list docker local docker images and versions )

for i in "${dockerImages[@]}"
do
  echo "Pull down image $i."
  docker pull $i
  number=$(docker images $i --format "{{.Tag}}")
  id=$(docker images $i --format "{{.ID}}")
  
  docker save $i | docker run -e TENABLE_ACCESS_KEY=$USER_NAME \
  -e TENABLE_SECRET_KEY=$USER_PASSWORD \
  -e IMPORT_REPO_NAME=jenkins \
  -i tenableio-docker-consec-local.jfrog.io/cs-scanner:{version} inspect-image $i
  
  curl -H "X-ApiKeys: accessKey=$USER_NAME; secretKey=$USER_PASSWORD" https://cloud.tenable.com/container-security/api/v1/reports/by_image?image_id=$id \
  | jq '.' > /scm/scripts/results/$i.txt
  
  policyStatus=$(curl -H "X-ApiKeys: accessKey=$USER_NAME; secretKey=$USER_PASSWORD" https://cloud.tenable.com/container-security/api/v1/policycompliance?image_id=$id | cut -d '"' -f 4)

done
