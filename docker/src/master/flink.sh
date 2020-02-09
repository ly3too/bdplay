#!/usr/bin/env bash

THIS_DIR=`dirname "$0"`
source ${THIS_DIR}/../common/flink.sh

echo "starting flink job manager"
start_job_manager
