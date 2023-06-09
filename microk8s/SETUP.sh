#!/bin/sh

# This is for my local cluster, which is using microk8s and Helm3.
# Everything is installing to a "registry" namespace.
# YMMV.

# Install the TLS certificate for the registry service hosts.
# Note that this is not included in the repo! You need to make this.
# It should contain a secret of type "tls" that contains credentials
# for an SSL cert for the two domain names that we use below for
# REGISTRY_HOST (the API server) and VIEWER_HOST (the viewer).
kubectl apply -f secret.yaml --namespace registry

helm install -n registry data bitnami/postgresql
helm install -n registry registry-server charts/registry-server
helm install -n registry registry-gateway charts/registry-gateway --set ingress.host=${REGISTRY_HOST}
helm install -n registry registry-viewer charts/registry-viewer --set ingress.host=${VIEWER_HOST} --set registry.url=https://${REGISTRY_HOST}
helm install -n registry registry-controller charts/registry-controller --set registry.project=menagerie
