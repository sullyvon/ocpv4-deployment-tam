#!/bin/bash

set -o nounset

DATETIME=`date +"%Y%m%d%H%M%S"`

#shame on me for no error handling
cluster_id=${1}
privileged_user=${2}
ocpv4_version=${3}
MIRROR_TO_REGISTRY=${4}
HTTPS_PROXY=${5}
NO_PROXY=${6}

export https_proxy=${HTTPS_PROXY}
export http_proxy=${HTTPS_PROXY}
export no_proxy=${NO_PROXY}

export PATH=/home/${privileged_user}/${ocpv4_version}:~/bin:$PATH
export KUBECONFIG=/home/${privileged_user}/${cluster_id}/installocpv4/auth/kubeconfig

RETURN_CODE=0

FILE="/home/${privileged_user}/${cluster_id}/${DATETIME}_mirror_adhoc_4u10.log"

exec &> >(tee ${FILE})

cd /home/${privileged_user}/${cluster_id} && oc-mirror --continue-on-error --max-per-registry 12 --dest-skip-tls --config /home/${privileged_user}/git/ocpv4-deployment/config/content_mirror/ocpv4u10/imageset-config-adhoc-4u10.yaml docker://${MIRROR_TO_REGISTRY}

if [ $? -ne 0 ]
then
  RETURN_CODE=1
  exit 1
fi
