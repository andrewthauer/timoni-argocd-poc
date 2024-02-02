# Timoni with ArgoCD POC

This is a POC to demonstrate the usage of [Timoni](https://timoni.sh/) with
[ArgoCD](https://argoproj.github.io/argo-cd/).

## Goals to Confirm

The following goals are to be confirmed with this POC:

- [x] Can we use Timoni as an ArgoCD CMP to render K8s manifests?
- [ ] Can we use Timoni along side helm charts in the same application?
- [ ] Can we pass arguments & parameters from ArgoCD Applications to Timoni
      bundles/modules?
- [ ] Can we replicate a non trival helm chart in Timoni/Cue?
- [ ] Is is the experience of managing Timoni modules & bundles better then
      helm?

## Running

```sh
# Make sure you have a local k8s cluster running (e.g. minikube, kind, etc.)
# brew install kind

# Build the argocd cmp plugin sidecar container image
# NOTE: This step may change based on the local k8s tool you are using
docker build -t argocd-cmp-timoni:latest ./argocd-cmp-timoni

# Copy the image to local cluster
# NOTE: This step may change based on the local k8s tool you are using
# kind load docker-image argocd-cmp-timoni:latest

kubectl apply -k argocd
# wait for argocd to be ready

# get the initial admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d | pbcopy

# port forward to the argocd server
kubectl port-forward svc/argocd-server -n argocd 8080:443

# open the argocd server
open https://localhost:8080

# apply the argocd app
kubectl apply -k apps/timoni-bundle.yaml
```
