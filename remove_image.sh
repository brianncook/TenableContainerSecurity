#!/bin/sh

#####
#
# Purpose: Remove image from Tenable Container Security.
#
# Requirement: Requires xmlstartlet
#
# Written by: Brian Cook
#               .1 Initial 2/26/18
#
####

ACCESS=$(xmlstarlet sel -t -m '//access' -v . -n < /scm/cs-page/data.xml)
SECRET=$(xmlstarlet sel -t -m '//secret' -v . -n < /scm/cs-page/data.xml)

echo "This script, when provided three pieces of information (name of repository, name of image, SHA256"
echo "hash) of an image in Tenable.io Container Security, will remove the image for the Tenable"
echo "Container Security registry."

read -p 'Enter name of repository: ' repo
read -p 'Enter name of image: ' name
read -p 'Enter the SHA256 of the image: ' sha

curl -H "X-ApiKeys: accessKey=$ACCESS; secretKey=$SECRET" -X DELETE https://cloud.tenable.com/container-security/api/v1/container/$repo/$name/manifests/$sha
