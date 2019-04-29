#!/usr/bin/env bash
set -euf

# Convert JPY_COOKIE_SECRET to Hex and add 3 characters
export JPY_COOKIE_SECRET=$(hexdump -ve '1/1 "%.2x"' <<< "$JPY_COOKIE_SECRET")

# Convert booleans at the end of lines to upper case
for f in hub.gflags jupyterhub_config.py; do
  sed -i \
      -e 's/false$/False/' \
      -e 's/true$/True/' \
      $f
done

# Convert .properties to .py file
for f in jupyterhub_config.py; do
  sed -r -i \
      -e '/=(False|True)$/! s/=(.*)/="\1"/' \
      $f
done

exec jupyterhub $(cat hub.gflags)