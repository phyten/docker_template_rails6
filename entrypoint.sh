#!/bin/sh

set -e

bundle install > /dev/null 2>&1

exec "$@"
