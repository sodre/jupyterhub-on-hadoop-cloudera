#!/usr/bin/env bash
set -euf

exec configurable-http-proxy $(cat node-http-proxy.gflags)