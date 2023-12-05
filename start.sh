#!/bin/bash

cd /app/ \
  && pipenv run mercury run 0.0.0.0:8000

sleep infinity

wait -n

# Exit with status of process that exited first
exit $?
