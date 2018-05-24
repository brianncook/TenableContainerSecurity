# TenableContainerSecurity

The files here were created by myself in oderer to increase my knowledge on how to integrate the Tenable.io platform into an Enterprise orginization DevOps lifecycle. The account to be used by the scripts need admon access.

Files
  data.xml - Holds the Tenable.io API Keys. Used by imageInfo.sh and imageWeb.sh.
  imageInfo.sh - Calls Tenable.io Container Security to get list of images, saves as a CSV file. Requires data.xml.
  imageWeb.sh - Reads the CSV file created by imageInfo.sh and creates an HTML page. Requires data.xml.
  remove_image.sh - Asks the end user three questions in order to remove an image(s) from Tenable Container Security.
  Jenkins_Pipeline_Example.txt - A sample pipeline script showing how to integrate Tenable Contianer Security into Jenkins.
    Software Requirement: csup to be installed where image is built. (https://github.com/tenable/csup)
    Tenable.io Container Security Requirement: Create a policy where CVSS => 6.0, set policy status to fail
