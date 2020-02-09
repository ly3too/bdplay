#!/usr/bin/env bash

JOB_MANAGER_RPC_ADDRESS=${JOB_MANAGER_RPC_ADDRESS:-$(hostname -f)}
CONF_FILE="${FLINK_HOME}/conf/flink-conf.yaml"

export FLINK_JOBMANAGER_HEAP_SIZE=${FLINK_JOBMANAGER_HEAP_SIZE:-1024m}
export FLINK_TASKMANAGER_HEAP_SIZE=${FLINK_TASKMANAGER_HEAP_SIZE:-1024m}
export FLINK_TASKMANAGER_NUM_SLOT=${FLINK_TASKMANAGER_NUM_SLOT:-`nproc --all`}

function subst_flink_conf {
    [ ! -z ${FLINK_CONF_BY_FILE} ] && ${FLINK_CONF_BY_FILE} && return 0
    envsubst < /opt/conf/flink/flink-conf.yaml.template > ${CONF_FILE}
    echo "config file: " && grep '^[^\n#]' "${CONF_FILE}"
}

function copy_plugins_if_required {
  if [ -z "$ENABLE_BUILT_IN_PLUGINS" ]; then
    return 0
  fi

  echo "Enabling required built-in plugins"
  for target_plugin in $(echo "$ENABLE_BUILT_IN_PLUGINS" | tr ';' ' '); do
    echo "Linking ${target_plugin} to plugin directory"
    plugin_name=${target_plugin%.jar}

    mkdir -p "${FLINK_HOME}/plugins/${plugin_name}"
    if [ ! -e "${FLINK_HOME}/opt/${target_plugin}" ]; then
      echo "Plugin ${target_plugin} does not exist. Exiting."
      exit 1
    else
      ln -fs "${FLINK_HOME}/opt/${target_plugin}" "${FLINK_HOME}/plugins/${plugin_name}"
      echo "Successfully enabled ${target_plugin}"
    fi
  done
}

function start_job_manager {
    copy_plugins_if_required
    subst_flink_conf

    gosu bdplay "$FLINK_HOME/bin/jobmanager.sh" start
}

function start_task_manager {
    copy_plugins_if_required
    subst_flink_conf

    gosu bdplay "$FLINK_HOME/bin/taskmanager.sh" start
}