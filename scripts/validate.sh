#!/usr/bin/env bash
#
#  vim:ts=2:sw=2:et
#
source scripts/env.sh

kubectl_opts="--insecure-skip-tls-verify --server=${KUBE_SERVER} --token=${KUBE_TOKEN} --namespace=${KUBE_NAMESPACE}"

log() {
  (2>/dev/null echo -e "$@")
}

info()   { log "--- $@"; }
error()  { log "[error] $@"; }
failed() { log "[failed] $@"; exit 1; }

info "kube api url: ${KUBE_SERVER}"
info "namespace: ${KUBE_NAMESPACE}"

deploy_resources() {

  info "deploying jenkins service to ci"
  if ! kd --insecure-skip-tls-verify \
    --namespace=${KUBE_NAMESPACE} \
    --timeout=5m \
    --check-interval=10s \
    -f kube/pvc.yaml \
    -f kube/deployment.yaml \
    -f kube/service.yaml; then
    return 1
  fi

  return $?
}

ret=0
if ! deploy_resources; then
  error "unable to deploy the jenkins in ci"
  ret=1
else
  info "successfully deployed the jenkins service"
fi

exit $ret
