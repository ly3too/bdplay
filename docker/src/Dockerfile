###############################################################################
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
# limitations under the License.
###############################################################################

# Install dependencies
RUN set -ex; \
  apt-get update; \
  apt-get -y install libsnappy1v5 gettext-base; \
  rm -rf /var/lib/apt/lists/*

# Grab gosu for easy step-down from root
ENV GOSU_VERSION 1.11
RUN set -ex; \
    apt -y install gosu;\
    gosu nobody true
RUN groupadd --system --gid=9999 bdplay && \
    useradd --system --home-dir $FLINK_HOME --uid=9999 --gid=bdplay bdplay

# env
ENV SCALA_VERSION=$SCALA_VERSION_ARG
ENV FLINK_VERSION=$FLINK_VERSION_ARG
ENV FLINK_HOME=/opt/flink
ENV PATH=$FLINK_HOME/bin:$PATH

# install flink
COPY flink /opt/

# install startup script
COPY common /opt/
COPY master /opt/
COPY worker /opt/
COPY conf /opt/

RUN chown -R bdplay:bdplay /opt

ENTRYPOINT ["/opt/start.sh"]
CMD ["help"]
