echo "creating cho core"
kubectl exec -it cho-local-solr-0 -- /opt/solr/bin/solr create_core -c cho

echo "finding local path for solr data"

host_path=$(kubectl get pv $(kubectl get pvc data-cho-local-solr-0 -o jsonpath='{.spec.volumeName}') -o jsonpath='{.spec.hostPath.path}')

echo "solr data is stored in $host_path"

echo "moving local configuration into cho core"

cp solr/config/schema.xml $host_path/cho/conf/schema.xml
cp solr/config/solrconfig.8.xml $host_path/cho/conf/solrconfig.xml

echo "restarting solr to take changes"
kubectl delete po cho-local-solr-0
