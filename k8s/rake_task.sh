
kubectl exec -it $(kubectl get pods -l app.kubernetes.io/name=cho -o jsonpath='{.items[0].metadata.name}') -- bundle exec rake $1
