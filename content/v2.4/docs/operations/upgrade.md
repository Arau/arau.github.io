---
title: Upgrade Ondat
description: Procedure to upgrade a Ondat v2 Cluster
alias:
    - /docs/operations/upgrades
---

This document details a step-by-step procedure to upgrade a Ondat v2
cluster.

Keep in mind that upgrading a cluster will require minor downtime of
applications using Ondat volumes. However we will take steps to minimize
the required downtime as much as possible.

## Upgrade Ondat

> Ensure that you have read the [PIDs prerequisite introduced in Ondat
> v2.3]({{< ref "/docs/prerequisites/pidlimits.md" >}}) and that you check the init container
> logs to ensure your environments PID limits are set correctly.

> Warning: To reduce downtime, it is recommended to `docker pull` the new
> Ondat container image `storageos/node:{{< param latest_node_version >}}`
> on the nodes beforehand so that the cluster spins up faster!

1. Make sure you keep a backup of all the Ondat yaml files. You can
   reuse the StorageOSCluster configuration file to easily upgrade your
   cluster. You can also backup the Statefulset yaml files to keep track of the
   replicas.

    ```bash
    kubectl get pod -n storageos-operator -o yaml > storageos_operator.yaml
    kubectl get storageoscluster -n storageos-operator -o yaml > storageos_cr.yaml
    kubectl get statefulset --all-namespaces > statefulset-sizes.yaml
    ```
    Note: If the storageos-api secret was created in the storageos-operator
    namespace then it will be deleted when the operator is deleted. In this
    case it will be necessary to recreate the Ondat API Secret.

    ```bash
    # Back up the Ondat API Secret
    SECRET_NAME=$(kubectl get storageoscluster -A -o=jsonpath='{.items[0].spec.secretRefName}')
    SECRET_NAMESPACE=$(kubectl get storageoscluster -A -o=jsonpath='{.items[0].spec.secretRefNamespace}')
    kubectl get secret -n $SECRET_NAMESPACE $SECRET_NAME -oyaml > /tmp/storageos-api-secret.yaml
    ```

1. Scale all stateful applications that use Ondat volumes to 0.

1. Delete the StorageOSCluster CR.
    ```bash
    CLUSTER_NAME=$(kubectl get storageoscluster -A -o=jsonpath='{.items[0].metadata.name}')
    CLUSTER_NAMESPACE=$(kubectl get storageoscluster -A -o=jsonpath='{.items[0].metadata.namespace}')
    kubectl delete storageoscluster $CLUSTER_NAME -n $CLUSTER_NAMESPACE
    ```
    If you have renamed the `StorageOSCluster` resource you can find it by
    using the command below.
    ```bash
    kubectl get storageoscluster --all-namespaces
    ```

1. Deploy the new operator.

    ```bash
    # Do not apply the yaml resources. It requires a deletion and posterior creation
    CURRENT_VERSION=$(kubectl -n storageos-operator get pod -o=jsonpath='{.items[0].spec.containers[0].image}' | cut -d':' -f2)
    kubectl delete -f https://github.com/storageos/cluster-operator/releases/download/${CURRENT_VERSION}/storageos-operator.yaml

    # Wait until the resources are deleted
    kubectl create -f https://github.com/storageos/cluster-operator/releases/download/{{< param latest_operator_version >}}/storageos-operator.yaml
    ```
    > Do not run a `kubectl apply`. A delete and create are needed

    > Warning: If you have made changes to the CRDs, Service Account or Cluster
    > Role, make sure you migrate those changes in the Ondat operator yaml.

1. Recreate the storageos-api secret (optional - only applies if the namespace
    was deleted per the above).

    ```bash
    kubectl create -f /tmp/storageos-api-secret.yaml
    ```

1. Edit the StorageOSCluster Custom Resource (storageos_cr.yaml) with the new
   node image version.
    ```yaml
    images:
        nodeContainer: "storageos/node:{{< param latest_node_version >}}"
    ```
    If you're not using any of the hardcoded container image versions make sure
    to delete them as well and only leave the nodeContainer image as shown
    above.
    
    Make sure to also delete all metadata that you're not using. The final
    metadata stanza should be something similar to that:
    ```yaml
    metadata:
        name: "cluster-storageos"
        namespace: "storageos-operator"
    ```

1. Re-create the StorageOSCluster
   ```yaml
   kubectl create -f storageos_cr.yaml
   ```
1. Wait for all the Ondat pods to enter the `RUNNING` state
    ```bash
    kubectl get pods -l app=storageos -A -w
    ```
1. Scale your stateful applications back up.

Congratulations, you now have the latest version Ondat.
