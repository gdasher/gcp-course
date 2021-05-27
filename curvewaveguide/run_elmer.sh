#!/bin/bash
set -e

HOSTFILE="/kube-openmpi/generated/hostfile"
OUT_FOLDER="$(TZ='America/Los_Angeles' date +%Y-%m-%d-%H-%M-%S)"

/usr/bin/mpiexec \
  -mca orte_keep_fqdn_hostnames true \
  -wdir /physics \
  --hostfile $HOSTFILE \
  -n 4 -npernode 1 /usr/local/bin/ElmerSolver_mpi

for host in $(cat $HOSTFILE); do
  ssh $host -- gsutil cp -n '/physics/output/*' "gs://gcp-security-dev-curriculum-data/${OUT_FOLDER}" || true
done

