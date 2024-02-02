# Timoni POC with ArgoCD

```sh
kubectl apply -k argocd
# wait for argocd to be ready

# get the initial admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d | pbcopy

# port forward to the argocd server
kubectl port-forward svc/argocd-server -n argocd 8080:443

# open the argocd server
open https://localhost:8080

# TODO
# create an ArgoCD application
```
