#!/bin/sh

#  imageWeb.sh
#  
#
#  Created by Brian Cook on 1/30/18.
#
#  Description: Read a file contianng informaiton about assets in Tenable.io
#    Container Security and generate a web page for end users. Provides a central
#    location and simplified view of what images exists and the associated risk score.
#

file="/scm/cs-page/imagesInfo.html"

[[ $# -ne 1 ]] && echo Usage: $0 [CSV_FN] && exit -1

CSV_FN=$1

cat <<EOF > $file
<html>
<head>
    <style type="text/css">
    table, th, tr, td {
        border: 1px solid black;
        border-style: solid;
        border-collapse: collapse;
        text-align: center;
    }
        th {
            background-color: #00A5B5;
            color: white;
        }
        td {
            background-color: #425363;
            color: white;
        }
    td.ten {
        color: #ff4040;
    }
    td.nine {
        color: #FF5531;
    }
    td.eight {
        color: #FF6326;
    }
    td.seven {
        color: #FF9305;
    }
    td.six {
        color: #FF9A01;
    }
    td.five {
        color: #E4AA2F;
    }
    td.four {
        color: #8AC7A9;
    }
    td.three {
        color: #84C4AA;
    }
    td.two {
        color: #6EB7AF;
    }
    td.one {
        color: #3797BA;
    }
    td.zero {
        color: #2C90BD;
    }
    .images {
        display: inline-block;
        margin-left: 40px;
        margin-right: 40px;
    }
</style>
</head>
<body>
    <header class="row module-actions no-select">
    <div class="container">
        <h1 class="title" align="center">
            <span class="descriptor">
            <strong>InfoSec</strong>
            </span>
        </h1>
        <a href="https://cloud.tenable.com" target="_blank">
           <img src="images/TenableLogo_FullColor_RGB.png" alt="Tenable.io Container Security" style="width:224px" class="images">
        </a>
    </div>
    </header>
    <br>
    <table border="1">
EOF

head -n 1 $CSV_FN |
sed -e 's/^/<tr><th>/' -e 's/,/<\/th><th>/g' -e 's/$/<\/th><\/tr>/' >> $file
tail -n +2 $CSV_FN |
sed -e 's/^/<tr><td>/' -e 's/,/<\/td><td>/g' -e 's/$/<\/td><\/tr>/' >> $file
printf "</table>\n" >> $file
printf "</body>" >> $file
printf "</html>" >> $file

perl -pi -w -e 's/<td>10.0<\/td>/<td class="ten">10.0<\/td>/g' $file
perl -pi -w -e 's/<td>9.0<\/td>/<td class="nine">9.0<\/td>/g' $file
perl -pi -w -e 's/<td>8.0<\/td>/<td class="eight">8.0<\/td>/g' $file
perl -pi -w -e 's/<td>7.0<\/td>/<td class="seven">7.0<\/td>/g' $file
perl -pi -w -e 's/<td>6.0<\/td>/<td class="six">6.0<\/td>/g' $file
perl -pi -w -e 's/<td>5.0<\/td>/<td class="five">5.0<\/td>/g' $file
perl -pi -w -e 's/<td>4.0<\/td>/<td class="four">4.0<\/td>/g' $file
perl -pi -w -e 's/<td>3.0<\/td>/<td class="three">3.0<\/td>/g' $file
perl -pi -w -e 's/<td>2.0<\/td>/<td class="two">2.0<\/td>/g' $file
perl -pi -w -e 's/<td>1.0<\/td>/<td class="one">1.0<\/td>/g' $file
perl -pi -w -e 's/<td>0.0<\/td>/<td class="zero">0.0<\/td>/g' $file

cp -a /scm/cs-page/imagesInfo.html /var/www/html/index.html
chcon -Rt httpd_sys_content_t /var/www/html/index.html
