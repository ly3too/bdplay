#!/usr/bin/env bash

THIS_DIR=`dirname "$0"`
source ${THIS_DIR}/../common/flink.sh

echo "starting flink job manager"
copy_plugins_if_required
subst_flink_conf
start_job_manager
start_task_manager
