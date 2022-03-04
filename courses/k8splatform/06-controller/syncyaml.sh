while [ ! -f "/usr/bin/inotifywait" ]; do
  sleep 0.2
done
while inotifywait -qq -r -e modify,create,delete,move /root/k8s-yaml-files/kube_apiserver_metrics; do
        rsync -qavz /root/k8s-yaml-files/kube_apiserver_metrics/conf.yaml node01:/root/k8s-yaml-files/kube_apiserver_metrics
done