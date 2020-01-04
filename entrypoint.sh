#!/bin/bash
# Read in the file of environment settings
if [ -d /home/finroc_user/finroc ]; then
  cd /home/finroc_user/finroc
  . scripts/setenv
  cd -
fi
# Then run the CMD
exec "$@"
