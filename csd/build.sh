#!/usr/bin/env bash
set -euf

# Convert the logo to an icon
convert -resize 16x16 images/logo.png images/icon.png

# Generate service.sdl file and validate it
yq . descriptor/service.sdl.yaml > descriptor/service.sdl
validator.sh -s descriptor/service.sdl

# Login to Cloudera Manager
CM_USR=admin
CM_PSW=$(sudo mdata-get admin_pw)
curl -s http://localhost:7180/cmf/login/j_spring_security_check \
     -c .cookie -d "j_username=${CM_USR}&j_password=${CM_PSW}"

# Reinstall the parcel
curl -b .cookie -s http://localhost:7180/cmf/csd/refresh | jq .
curl -b .cookie -s http://localhost:7180/cmf/csd/uninstall?csdName=$(basename $(pwd))\&force=true | jq .
curl -b .cookie -s http://localhost:7180/cmf/csd/install?csdName=$(basename $(pwd)) | jq .
