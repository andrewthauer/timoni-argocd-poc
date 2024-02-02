#!/usr/bin/env bash

set -eo pipefail

# TODO: Extract parameters and pass to renderers
# ARGOCD_APP_PARMETERS=""
# ARGOCD_ENV_*

# Available ARGOCD environment variables
#   - KUBE_VERSION
#   - KUBE_API_VERSIONS
#   - ARGOCD_APP_NAME
#   - ARGOCD_APP_NAMESPACE
#   - ARGOCD_APP_REVISION
#   - ARGOCD_APP_PARAMETERS (json of parameters provided by spec.source.plugin.parameters)
#   - ARGOCD_ENV_* (variables provided by spec.source.plugin.env)

export APP_NAME="${ARGOCD_APP_NAME}"
export APP_NAMESPACE="${ARGOCD_APP_NAMESPACE}"
# export APP_ENV="${ARGOCD_APP_NAMESPACE}"

# Generate the bundle
# TODO: Make the bundle cue file a parameters
if [ -f "bundle.cue" ]; then
  /usr/local/bin/timoni bundle build -f bundle.cue --runtime-from-env
fi

if [ -f "Chart.yaml" ]; then
  # TODO: Accept parameters to apply values files or other helm parameters
  /usr/local/bin/helm template chart .
fi

if [ -f "kustomization.yaml" ]; then
  /usr/local/bin/kustomize build .
fi
