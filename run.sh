#!/bin/bash

export KUBE_NAMESPACE=default
export MPI_CLUSTER_NAME=elmer

helm template kube-openmpi/chart \
  --namespace $KUBE_NAMESPACE \
  --name-template $MPI_CLUSTER_NAME \
  -f values.yaml -f ssh-key.yaml \
  | kubectl -n $KUBE_NAMESPACE apply -f -
