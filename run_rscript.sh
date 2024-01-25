#!/usr/bin/env bash

if [ $# -lt 1 ]; then
  echo "usage: `basename $0` workdir [args ...]"

  exit 1
fi

workdir=$1

shift

singularity exec --bind "$workdir":/home/work --pwd /home/work --cleanenv --writable-tmpfs cmdstanr.sif entrypoint "$@"
