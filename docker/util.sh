#!/usr/bin/env bash

function verify_asc {
    ASC_FILE=$1
    TARGET_FILE=$2
    GPG_KEY=$3

    GNUPGHOME="$(mktemp -d)"; \
    for server in ha.pool.sks-keyservers.net $(shuf -e \
                          hkp://p80.pool.sks-keyservers.net:80 \
                          keyserver.ubuntu.com \
                          hkp://keyserver.ubuntu.com:80 \
                          pgp.mit.edu) ; do \
      gpg --batch --keyserver "$server" --recv-keys "$GPG_KEY" && break || : ; \
    done && \
    gpg --batch --verify $ASC_FILE $TARGET_FILE;
    ret=$?
    gpgconf --kill all; \
    rm -rf "$GNUPGHOME"
    return $ret
}

function download_and_verify_asc {
    TGZ_URL=$1
    ASC_URL=$2
    TGZ_SAVE_NAME=$3
    ASC_SAVE_NAME=$4
    GPG_KEY=$5

    if [[ -f $DOWNLOAD_DIR/$TGZ_SAVE_NAME && -f $DOWNLOAD_DIR/$ASC_SAVE_NAME && \
        verify_asc $DOWNLOAD_DIR/$ASC_SAVE_NAME $DOWNLOAD_DIR/$TGZ_SAVE_NAME $GPG_KEY ]]; then
        return 0
    else
        rm $DOWNLOAD_DIR/$ASC_SAVE_NAME $DOWNLOAD_DIR/$TGZ_SAVE_NAME
    fi

    wget -nv -O $DOWNLOAD_DIR/$TGZ_SAVE_NAME $TGZ_URL
    wget -nv -O $DOWNLOAD_DIR/$ASC_SAVE_NAME $ASC_URL

    if [[ ! (-f $DOWNLOAD_DIR/$TGZ_SAVE_NAME && -f $DOWNLOAD_DIR/$ASC_SAVE_NAME && \
        verify_asc $DOWNLOAD_DIR/$ASC_SAVE_NAME $DOWNLOAD_DIR/$TGZ_SAVE_NAME $GPG_KEY) ]]; then
        rm $DOWNLOAD_DIR/$ASC_SAVE_NAME $DOWNLOAD_DIR/$TGZ_SAVE_NAME
        exit 1
    fi
}