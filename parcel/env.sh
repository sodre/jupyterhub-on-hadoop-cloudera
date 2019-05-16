# We can not use conda-unpack at this point because the process sourcing 
# this file does not have write access to the parcel directory.
if [ "$PARCELS_ROOT" != "/opt/cloudera/parcels" ]; then
  cat <<EOF
ERROR: Unsuported PARCELS_ROOT directory.
  The JupyterHub parcel can only be installed in Cloudera's default 
  parcel location (/opt/cloudera/parcels), but your parcel
  location is $PARCELS_ROOT.

  Please go to github.com/sodre/jupyterhub-parcel for instructions 
  on how to regenerate this parcel to match your cluster configuration.
EOF
  exit 2
fi

source $PARCELS_ROOT/$PARCEL_DIRNAME/bin/activate
