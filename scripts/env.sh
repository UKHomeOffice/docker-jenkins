#!/usr/bin/env bash -e

export DRONE_DEPLOY_TO=${DRONE_DEPLOY_TO:-acp}
export JENKINS_VERSION="latest"
export JENKINS_HOME_VOLUME_SIZE="20Gi"
export PROJECT="acp"

case "${DRONE_DEPLOY_TO}" in
  "${PROJECT}")
    export KUBE_NAMESPACE="${PROJECT}-jenkins"
    export KUBE_SERVER="${KUBE_SERVER_ACP_CI}"
    export KUBE_TOKEN="${KUBE_TOKEN_ACP_CI}"
    export DNS="${PROJECT}-jenkins.ci.acp.homeoffice.gov.uk"
    ;;
  *)
    echo "The environment: ${DRONE_DEPLOY_TO} does is not configured"
    exit 1
    ;;
esac
