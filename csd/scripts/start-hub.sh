#!/usr/bin/env bash
set -euf

# Convert JPY_COOKIE_SECRET to Hex and add 3 characters
export JPY_COOKIE_SECRET=$(hexdump -ve '1/1 "%.2x"' <<< "$JPY_COOKIE_SECRET")

exec jupyterhub $(cat hub.gflags)