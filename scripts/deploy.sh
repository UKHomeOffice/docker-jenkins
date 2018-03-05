#!/usr/bin/env bash

source scripts/env.sh

log() {
  (2>/dev/null echo -e "$@")
}

info()   { log "--- $@"; }
error()  { log "[error] $@"; }
failed() { log "[failed] $@"; exit 1; }

info "kube api url: ${KUBE_SERVER}"
info "namespace: ${KUBE_NAMESPACE}"

if [[ "${DRONE_DEPLOY_TO}" == "acp-ci" ]]; then
  info "kicking off the ci build"
  if ! scripts/validate.sh; then
    failed "jenkins ci validation"
    exit 1
  fi
  exit 0
else

  info "deploying to environment"
  kd --insecure-skip-tls-verify \
     --check-interval=5s \
     --timeout=5m \
     --namespace=${KUBE_NAMESPACE} \
     -f kube/pvc.yaml \
     -f kube/ingress.yaml \
     -f kube/service.yaml \
     -f kube/networkpolicy.yaml \
     -f kube/deployment.yaml
  if [[ $? -ne 0 ]]; then
    failed "rollout of deployment"
    exit 1
  fi

  info "checking the health endpoint for jenkins"
  if ! curl --silent --fail --retry 20 --retry-delay 20 --insecure \
      https://${DNS}}/; then
    failed "verification of health via endpoint"
    exit 1
  fi
fi

exit $?
