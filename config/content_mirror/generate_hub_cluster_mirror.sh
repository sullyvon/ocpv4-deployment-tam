#!/bin/bash

set -o nounset

dsulliva-hub01_endpoint="hub-registry-quay-quay-enterprise.apps.dsulliva-hub01.nasatam.support"
dsulliva-hub02_endpoint="hub-registry-quay-quay-enterprise.apps.dsulliva-hub01.nasatam.support"

endpoint_mirror=""
endpoint_mirror_from=""
MANIFEST_DESIRED_FILE=""
MIRROR_TO_CLUSTER=""
MIRROR_FROM_CLUSTER=""

mirror_array=()

usage() {
  echo "$0 -f mapping.txt -m dsulliva-hub01 -c dsulliva-hub02"
  exit 0
}

while getopts ":f:m:c:h" arg
do
   case ${arg} in
     h)
       usage
       ;;
     f)
       MANIFEST_DESIRED_FILE=$OPTARG
       #echo ${project}
       ;;
     m)
       MIRROR_FROM_CLUSTER=$OPTARG
       if [ "${MIRROR_FROM_CLUSTER}" = "dsulliva-hub01" ]
       then
          endpoint_mirror_from="${dsulliva-hub01_endpoint}"
       else
         usage
       fi
       #echo ${image}
       ;;
     c)
       MIRROR_TO_CLUSTER=$OPTARG
       if [ "${MIRROR_TO_CLUSTER}"  = "dsulliva-hub02" ]
       then
          endpoint_mirror="${dsulliva-hub01_endpoint}"
       else
         usage
       fi
       #echo ${image}
       ;;
   esac
done
shift $((OPTIND-1))

if [ -z "${MANIFEST_DESIRED_FILE}" ] || [ -z "${MIRROR_TO_CLUSTER}" ] || [ -z "${MIRROR_FROM_CLUSTER}" ]
then
  usage
fi

while read line
do

   #value="$(grep ${line} ${MANIFEST_ALL_FILE} 2> /dev/null)"
   src="$(echo "${line}" | awk -F  "=" '{print $2}' | cut -d"@" -f1)"
   
   #echo ${src}
   dst="$(echo "${src}" | sed "s/$endpoint_mirror_from/$endpoint_mirror/g")"
   mirror_repo="$(echo "${src}=${dst}")"
   mirror_array+=(${mirror_repo})
   #echo "###FROM $endpoint_mirror_from"
   #echo "###TO $endpoint_mirror"
   ##dest="$(echo "${src}" | sed "s/$endpoint_mirror_from/$endpoint_mirror/g")"
   ##echo "${src}=${dest}"

done < ${MANIFEST_DESIRED_FILE} 


printf '%s\n' "${mirror_array[@]}" | sort -u
