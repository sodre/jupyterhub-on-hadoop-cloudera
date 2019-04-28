#!/usr/bin/env bash
set -euf

# Convert the logo to an icon
convert -resize 16x16 images/logo.png images/icon.png

# Generate service.sdl file and validate it
yq . descriptor/service.sdl.yaml > descriptor/service.sdl
validator.sh -s descriptor/service.sdl

# Restart/Reload the CSD
if [[ ! -e .cookie ]]; then
  CM_USR=admin
  CM_PSW=$(sudo mdata-get admin_pw)
  curl -s http://localhost:7180/cmf/login/j_spring_security_check \
       -c .cookie -d "j_username=${CM_USR}&j_password=${CM_PSW}"
fi

# Reinstall the parcel
curl -b .cookie -s http://localhost:7180/cmf/csd/uninstall?csdName=JUPYTERHUB-0.0.1 | jq .
curl -b .cookie -s http://localhost:7180/cmf/csd/install?csdName=JUPYTERHUB-0.0.1 | jq .
