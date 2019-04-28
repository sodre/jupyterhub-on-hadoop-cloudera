#!/usr/bin/env bash
set -euf

exec jupyterhub $(cat hub.gflags)