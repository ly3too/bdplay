#!/usr/bin/env bash

BASE_IMAGE=openjdk:8-jre
THIS_DIR=`dirname $0`
BUILD_DIR=${THIS_DIR}/build
DOWNLOAD_DIR=${THIS_DIR}/download

. ${THIS_DIR}/util.sh

#base config
SCALA_VERSION=2.11

APACHE_MIRROR_URL=https://mirrors.tuna.tsinghua.edu.cn/apache/


#flink configuration
FLINK_VERSION=1.9.2

FLINK_URL_FILE_PATH=flink/flink-${FLINK_VERSION}/flink-${FLINK_VERSION}-bin-scala_${SCALA_VERSION}.tgz
FLINK_TGZ_SAVE_NAME=`basename ${FLINK_URL_FILE_PATH}`
FLINK_ASC_SAVE_NAME=${FLINK_TGZ_SAVE_NAME}.asc
FLINK_TGZ_URL=${APACHE_MIRROR_URL}${FLINK_URL_FILE_PATH} 
FLINK_ASC_URL=https://www.apache.org/dist/${FLINK_URL_FILE_PATH}.asc
FLINK_GPG_KEY=EF88474C564C7A608A822EEC3FF96A2057B6476C


# create dirs
rm -rf $BUILD_DIR && mkdir -p $BUILD_DIR
[ -d $DOWNLOAD_DIR ] || mkdir -p $DOWNLOAD_DIR

# download and unpack flink
download_and_verify_asc $FLINK_TGZ_URL $FLINK_ASC_URL $FLINK_TGZ_SAVE_NAME $FLINK_ASC_SAVE_NAME $FLINK_GPG_KEY
mkdir -p $BUILD_DIR/flink && tar -xvzf ${DOWNLOAD_DIR}/${FLINK_TGZ_SAVE_NAME} --strip-components 1 -C $BUILD_DIR/flink/


# build docker
cp -rf $THIS_DIR/src/* $BUILD_DIR/
cd $BUILD_DIR
docker build -t bdplay --build-arg SCALA_VERSION_ARG=$SCALA_VERSION FLINK_VERSION_ARG=$FLINK_VERSION .
