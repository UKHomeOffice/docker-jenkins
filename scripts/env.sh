#!/usr/bin/env bash -e

export DRONE_DEPLOY_TO=${DRONE_DEPLOY_TO:-project-jenkins}
export JENKINS_VERSION="latest"
export JENKINS_HOME_VOLUME_SIZE="20Gi"

case "${DRONE_DEPLOY_TO}" in
  acp-ci)
    export KUBE_NAMESPACE="jenkins-ci"
    export KUBE_SERVER="${KUBE_SERVER_ACP_CI}"
    export KUBE_TOKEN="${KUBE_TOKEN_ACP_CI}"
    export DNS_DOMAIN="${KUBE_NAMESPACE}.ci.acp.homeoffice.gov.uk"
    export DNS="${DNS_DOMAIN}"
    ;;
  project-jenkins)
    export KUBE_NAMESPACE="project-jenkins"
    export KUBE_SERVER="${KUBE_SERVER_ACP_CI}"
    export KUBE_TOKEN="${KUBE_TOKEN_ACP_CI}"
    export DNS_DOMAIN="${KUBE_NAMESPACE}.ci.acp.homeoffice.gov.uk"
    export DNS="${DNS_DOMAIN}"
    ;;
  *)
    echo "The environment: ${DRONE_DEPLOY_TO} does is not configured"
    exit 1
    ;;
esac
