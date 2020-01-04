#!/bin/bash
# Read in the file of environment settings
if [ -d /home/finroc_user/finroc ]; then
  cd /home/finroc_user/finroc
  . scripts/setenv
  cd -
fi

if [ ! -f /home/finroc_user/.bashrc ]; then
  if [ -f /.bashrc ]; then
    cp /.bashrc /home/finroc_user
  fi
fi
# Then run the CMD
exec "$@"
