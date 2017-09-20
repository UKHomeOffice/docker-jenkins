#!/usr/bin/env bash -e

export DRONE_DEPLOY_TO=${DRONE_DEPLOY_TO:-acp-ci}
export JENKINS_VERSION="latest"
export JENKINS_HOME_VOLUME_SIZE="20Gi"

case "${DRONE_DEPLOY_TO}" in
  acp-ci)
    export KUBE_NAMESPACE="jenkins-ci"
    export KUBE_SERVER="${KUBE_SERVER_ACP_CI}"
    export KUBE_TOKEN="${KUBE_TOKEN_ACP_CI}"
    export DNS_DOMAIN="${KUBE_NAMESPACE}.svc.cluster.local"
    export DNS="jenkins.${DNS_DOMAIN}"
    ;;
  *)
    echo "The environment: ${DRONE_DEPLOY_TO} does is not configured"
    exit 1
    ;;
esac
