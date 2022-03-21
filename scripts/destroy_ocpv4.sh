$!/bin/bash

set -o nounset

DATETIME=`date +"%Y%m%d%H%M%S"`

#shame on me for no error handling
cluster_id=$1
privileged_user=$2

RETURN_CODE=0

FILE="/home/${privileged_user}/${cluster_id}/${DATETIME}_destroy_ocpv4.log"

exec &> >(tee ${FILE})

source /home/${privileged_user}/${cluster_id}/core_env

/home/${privileged_user}/openshift-install destroy cluster --dir=/home/${privileged_user}/${cluster_id}/installocpv4 --log-level=debug

if [ $? -ne 0 ]
then
  RETURN_CODE=1
  exit 1
fi
