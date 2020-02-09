#!/usr/bin/env bash

THIS_DIR=`dirname "$0"`
source ${THIS_DIR}/../common/flink.sh

echo "starting flink task manager"
start_task_manager