#!/bin/bash

LATEST="8.1.0"

for version in nightly 8.0.0 8.1.0 ; do
  echo "Building: ${version}"
#  docker build -t tigase/tigase-xmpp-server:${version} -f ${version}/Dockerfile --no-cache ${version}/
#  docker push tigase/tigase-xmpp-server:${version}
  if [[ "${LATEST}" == "${version}" ]] ; then
    echo "Pushing ${version} as latest"
    docker tag tigase/tigase-xmpp-server:${version} tigase/tigase-xmpp-server:latest
    docker push tigase/tigase-xmpp-server:latest
  fi
done