#!/bin/sh

####
#
#  csupImagePolicyOnly.sh
#  
#
#  Created by Brian Cook on 6/29/18.
#  
###

ACCESS=$(xmlstarlet sel -t -m '//access' -v . -n < /scm/cs-page/data.xml)
SECRET=$(xmlstarlet sel -t -m '//secret' -v . -n < /scm/cs-page/data.xml)

dockerImages=($(docker images --format "{{.ID}}"))

if [ ! -d "/scm/results" ]; then
  mkdir /scm/results
fi

for i in "${dockerImages[@]}"
do
  csup --access-key $ACCESS --secret-key $SECRET policy $i
done
