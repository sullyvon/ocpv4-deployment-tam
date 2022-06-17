#!/bin/bash

while [ 1 ]
do
    data=$(oc get ip --all-namespaces --no-headers | grep "false" | awk -F' ' '{print $1 "," $2}')
    for line in ${data}
    do
        project=$(echo "$line" | awk -F',' '{print $1}')
        ip=$(echo "$line" | awk -F',' '{print $2}')
         
         echo "approving ${ip} for ${project}" 
         ~/4.10.12/oc -n ${project} patch installplan ${ip}  -p '{"spec":{"approved":true}}' --type merge
         
    done
done
