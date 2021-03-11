#!/bin/bash

TIGASE_DOCKER_IMAGE="${TIGASE_DOCKER_IMAGE:-tigase/tigase-xmpp-server}"
LATEST="8.1.1"

for release in nightly 8.1.1-b10861-dist-max 8.1.0-b10857-dist-max 8.0.0-b10083-dist-max; do
  version=$(echo $release | cut -d'-' -f1)
  major=$(echo $version | cut -d'.' -f1)
  echo "Building: ${version}"
  docker build -t ${TIGASE_DOCKER_IMAGE}:${version} -f ./${major}/Dockerfile --build-arg TIGASE_VERSION=${version} --build-arg TIGASE_RELEASE=${release} --no-cache  ./${major}
  docker push ${TIGASE_DOCKER_IMAGE}:${version}
  if [[ "${LATEST}" == "${version}" ]] ; then
    echo "Pushing ${version} as latest"
    docker tag ${TIGASE_DOCKER_IMAGE}:${version} ${TIGASE_DOCKER_IMAGE}:latest
    docker push ${TIGASE_DOCKER_IMAGE}:latest
  fi
done
