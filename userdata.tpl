#!/bin/bash
set -o xtrace
${before_cluster_joining_userdata}
/etc/eks/bootstrap.sh --apiserver-endpoint '${cluster_endpoint}' --b64-cluster-ca '${certificate_authority_data}' ${bootstrap_extra_args} '${cluster_name}'
${after_cluster_joining_userdata}
