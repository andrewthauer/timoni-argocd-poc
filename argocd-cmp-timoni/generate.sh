#!/usr/bin/env bash

set -eo pipefail

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

render_timoni_bundle() {
  # Generate the bundle
  # TODO: Make the bundle cue file a parameters
  timoni bundle build -f bundle.cue --runtime-from-env
}

render_helm_chart() {
  values_files="$(echo "$ARGOCD_APP_PARAMETERS" |
    jq -r '.[]
      | select(.name=="helmValueFiles")
      | if .array == null then {} else .array end
      | map("-f " + .)
      | join(" ")
    ' | xargs)"

  values="$(echo "$ARGOCD_APP_PARAMETERS" |
    jq -r '.[]
      | select(.name=="helmParameters")
      | if .map == null then {} else .map end
      | to_entries
      | map(.key + "=\"" + .value + "\"")
      | join(",")
    ' | xargs)"

  if [ "$values" != "" ]; then
    values="--set $values"
  fi

  # TODO: Add support for setting up helm repos
  #       this might be better to do in the init.sh??
  # See https://github.com/argoproj/argo-cd/issues/10265
  # helm repo add

  # Build the helm dependencies
  helm dependency build >&2

  # shellcheck disable=SC2086
  helm template "$APP_NAME" . $values_files $values
}

render_kustomize() {
  kustomize build .
}

main() {
  if [ -f "bundle.cue" ]; then
    render_timoni_bundle
  fi

  if [ -f "Chart.yaml" ]; then
    render_helm_chart
  fi

  if [ -f "kustomization.yaml" ]; then
    render_kustomize
  fi
}

main "$@"
