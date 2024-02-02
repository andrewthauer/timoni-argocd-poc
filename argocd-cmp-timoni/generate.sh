#!/usr/bin/env bash

set -eo pipefail

# TODO: Extract parameters and pass to renderers
# ARGOCD_ENV_PARMETERS=""
# ARGOCD_ENV_*

if [ -f "Chart.yaml" ]; then
  # TODO: Accept parameters from values files
  helm template chart .
fi

if [ -f "kustomization.yaml" ]; then
  kustomize build .
fi

# Generate the bundle
# TODO: Make the bundle cue file a paramters
if [ -f "bundle.cue" ]; then
  /usr/local/bin/timoni bundle build -f bundle.cue
fi
