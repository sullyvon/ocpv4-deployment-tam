*Mirroring From Connected Hub To Partially Disconnected Hub"

After running the following playbook on you hub cluster that is connected

common-post-hub-mirror-ocpv4-catalog.yml

You then want to process the catalog mapping.txt that is created

/home/dsulliva/dsulliva-hub01/oc-mirror-workspace/results-1654631049

bash generate_hub_cluster_mirror.sh -f /home/dsulliva/dsulliva-hub01/oc-mirror-workspace/results-1654631049/mapping.txt -m dsulliva-hub01 -c dsulliva-hub02 > dsulliva-hub02_mapping.txt

Once that is process you can then run the common-post-hub-mirror-ocpv4-catalog.yml playbook against the dsulliva-hub02 cluster
