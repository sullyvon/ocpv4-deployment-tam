#!/bin/bash

set -o nounset

DATETIME=`date +"%Y%m%d%H%M%S"`

#shame on me for no error handling
cluster_id=$1
privileged_user=$2
ocpv4_version=$3

export PATH=/home/${privileged_user}/${ocpv4_version}:$PATH
export KUBECONFIG=/home/${privileged_user}/${cluster_id}/installocpv4/auth/kubeconfig

RETURN_CODE=0

FILE="/home/${privileged_user}/${cluster_id}/${DATETIME}_install_ocpv4.log"

exec &> >(tee ${FILE})

openshift-install create cluster --dir=/home/${privileged_user}/${cluster_id}/installocpv4 --log-level=debug

if [ $? -ne 0 ]
then
  RETURN_CODE=1
  exit 1
fi
