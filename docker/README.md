# bigdata playground - bdplay
A docker image to easily deploy bigdata stack in cluster. Bdplay includes kafka, hadoop, flink, spark etc.

## deployment
every bigdata software is installed under /opt director.

start master simply by CMD: `master`.

start worker simply by CMD: `worker`.

All configurations are done by docker environment variables or directly by config files.

## flink

Currently, flink deployment support only single jobmanager. considering multi jobmanager support in the future.

### configuration
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

### port map

|------|------------------------------------|
|port--|description-------------------------|
|6123  |jobmanager.rpc.port, used to submit jobs. |
|8081  |web front end  |


## hadoop

### configuration
refer to [hadoop deploy doc](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/ClusterSetup.html)

- etc/hadoop/core-site.xml
- etc/hadoop/hdfs-site.xml
- etc/hadoop/yarn-site.xml
- etc/hadoop/mapred-site.xml

### env:
|------|------------------------------------|
|key---|-   default      -|----------------description------------------|
|HDFS_NAME_DIR| /data/hadoop/hdfs/name/ | namenode dir, need not to change |
|HDFS_DATA_DIR| /data/hadoop/hdfs/data/ | datanode dir, need not to change |
|HDFS_REPLICATION| 1 | hdfs data replication |
|YARN_NODE_RES_MEM_MB| 8192 | Defines total available resources on the NodeManager to be made available to running containers |
|HADOOP_CONFIG_BY_FILE| - | set to true if you want to use config map |



### port map

|------|------------------------------------|
|port--|description-------------------------|
|9000  | hdfs server port |
|9870  | hdfs web front end  |
|8088  | resource manager webui |
|19888 | job history server webui|
|10020 | job history rpc port |

## spark

### env
for detailed env config, check out [spark documentation](https://spark.apache.org/docs/latest/)

useful docker env variables
|------|------------------------------------|
|key---|-   default      -|----------------description------------------|
|SPARK_MASTER_HOST| localhost | spark master host |

### port map
|------|------------------------------------|
|port--|description-------------------------|
|7077  | spark server port |
|8082  | spark web ui port |

## kafka
### env
|------|------------------------------------|
|key---|-   default      -|----------------description------------------|
|KAFKA_ENABLED| true | enable kafka on each worker |
|KAFKA_ZOOKEEPER_CONNECT | - | comma separated zookeeper host:port, if kafak enabled this variable is required |
|KAFKA_CONF_BY_FILE | - | set to true if use direct file config |

### port map
|------|------------------------------------|
|port--|description-------------------------|
|9092  | kafka listen port |