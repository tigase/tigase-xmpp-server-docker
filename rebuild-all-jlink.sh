#!/bin/bash

for JDK_VERSION in 17 21 25 ; do
  echo "Building: ${JDK_VERSION}"

  docker buildx build --platform linux/amd64,linux/arm64 --build-arg JDK_VERSION=${JDK_VERSION:-25} -t tigase/tigase-xmpp-server-base:${JDK_VERSION:-25}${ALPINE:+-$ALPINE} -f jre-jlink-base/Dockerfile${ALPINE:+-$ALPINE} --no-cache jre-jlink-base --push

  export ALPINE="alpine"
  docker buildx build --platform linux/amd64,linux/arm64 --build-arg JDK_VERSION=${JDK_VERSION:-25} -t tigase/tigase-xmpp-server-base:${JDK_VERSION:-25}${ALPINE:+-$ALPINE} -f jre-jlink-base/Dockerfile${ALPINE:+-$ALPINE} --no-cache jre-jlink-base --push
  unset ALPINE

done