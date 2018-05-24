#!/bin/bash

#  imageInfo.sh
#
#  Prereq: Need xmlstartlet installed.
#
#  Created by Brian Cook on 1/30/18.
#

ACCESS=$(xmlstarlet sel -t -m '//access' -v . -n < /scm/cs-page/data.xml)
SECRET=$(xmlstarlet sel -t -m '//secret' -v . -n < /scm/cs-page/data.xml)

curl -H "X-ApiKeys: accessKey=$ACCESS; secretKey=$SECRET" https://cloud.tenable.com/container-security/api/v1/container/list | jq -r 'sort_by(.score, .repo_name, .name) | ["Score", "Repository", "Name", "# of Vulnerabilities", "Size", "Digest", "Uploaded Date", "Last Scanned Date", "ID"], (.[] | [.score, .repo_name, .name, .number_of_vulnerabilities, .size, .digest, .created_at, .updated_at, .id]) | @csv' | awk '{gsub(/\"/,"")};1' > /scm/cs-page/container_security.csv

/scm/cs-page/imageWeb.sh /scm/cs-page/container_security.csv
