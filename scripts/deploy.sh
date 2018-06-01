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

info "downloading ca for kube api"
if ! curl --silent --fail --retry 5 \
    https://raw.githubusercontent.com/UKHomeOffice/acp-ca/master/acp-ci.crt -o /tmp/ca.crt; then
  failed "downloading ca for kube api"
  exit 1
fi

KD_OPTS="--certificate-authority=/tmp/ca.crt --check-interval=5s --timeout=5m --namespace=${KUBE_NAMESPACE}"

info "deploying to environment"
kd ${KD_OPTS} \
   -f kube/pvc.yaml \
   -f kube/ingress.yaml \
   -f kube/service.yaml \
   -f kube/networkpolicy.yaml \
   -f kube/deployment.yaml
if [[ $? -ne 0 ]]; then
  failed "rollout of deployment"
  exit 1
fi

exit $?
