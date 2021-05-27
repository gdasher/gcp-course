#!/bin/bash
set -e

HOSTFILE="/kube-openmpi/generated/hostfile"

/usr/bin/mpiexec \
  -mca orte_keep_fqdn_hostnames true \
  -wdir /physics \
  --hostfile $HOSTFILE \
  -n 4 -npernode 1 /usr/local/bin/ElmerSolver_mpi
