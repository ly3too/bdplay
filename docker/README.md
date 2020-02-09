# bigdata playground - bdplay
A docker image to easily deploy bigdata stack in cluster. Bdplay includes kafka, hadoop, flink, spark etc.

## deployment
every bigdata software is installed under /opt director.

start master simply by CMD: `master`.

start worker simply by CMD: `worker`.

All configurations are done by docker environment variables or directly by config files.

## flink configuration
file: /opt/flink/conf/flink-conf.yaml

template: /opt/conf/flink/flink-conf.yaml.template

environment variables:
```
FLINK_JOBMANAGER_HEAP_SIZE: flink jobmanager heap size, default 1024m
FLINK_TASKMANAGER_HEAP_SIZE: flink taskmanager heap size, default 1024m
FLINK_TASKMANAGER_NUM_SLOT: flink number of task slots,  default number of cpu cores
FLINK_CONF_BY_FILE: default empty, if set to true, environment variables substitution will not take effect
ENABLE_BUILT_IN_PLUGINS: semi-colon separated plugin names
```

##
