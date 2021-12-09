---
title: Uninstall Ondat
description: Procedure to remove a Ondat cluster permanently
---

This document details a step-by-step procedure to remove Ondat from a
Kubernetes cluster.

Remember that Ondat enables the stateful applications within your cluster.
It is very important to remove any applications that rely on Ondat before
you remove Ondat itself, or those applications will suffer unrecoverable
errors.

## Remove Stateful Workloads and Data

1. Delete any resources using Ondat volumes

    Delete any statefulsets, deployments or pods that are using Ondat Volumes.

1. Delete PVCs using Ondat

    Delete any Persistent Volume Claims that are using Ondat.

    ```bash
    $ kubectl -n $NS delete pvc $PVC
    ```

    > **This will delete data held by Ondat and won't be recoverable.**

## Remove Ondat Cluster

1. Delete Ondat Cluster

    ```bash
    $ kubectl get storageoscluster --all-namespaces # Find the namespace where the Custom Resource runs
    $ kubectl -n $NS delete storageoscluster --all  # Usually to be found in storageos-operator
    ```
1. Wait until the Ondat resources are gone

    ```bash
    $ kubectl -n kube-system get pod # NS: Namespace where Ondat Daemonset is running, usually 'kube-system'
    ```
## Uninstall the Ondat Operator

> **Delete the Cluster Operator once the Ondat Pods are terminated**

1. Delete the Ondat Operator deployment

    ```bash
    $ kubectl delete -f https://github.com/storageos/cluster-operator/releases/download/{{< param latest_operator_version >}}/storageos-operator.yaml
    ```
**Procedure is finished. Ondat is now uninstalled.**

## Remove Ondat contents and metadata (unrecoverable)

The steps up until now have been recoverable - as long as the etcd backing
Ondat and the contents of /var/lib/storageos on your nodes are safe then
Ondat can be reinstalled. For complete removal and recovery of disk space,
you can use the following procedure.

> **The following steps will delete all data held by Ondat and won't be
> recoverable.**

1. Remove the Ondat data directory

    There are two ways to remove the Ondat data directory:

    1. (Option 1) Login in to the hosts and execute the following commands

        ```bash
        $ sudo rm -rf /var/lib/storageos
        $ sudo umount /var/lib/kubelet/plugins_registry/storageos
        ```

    1. (Option 2) Execute the following command to deploy a DaemonSet that removes the
       Ondat data directory.

        > **N.B This step is irreversible and once the data is removed it cannot
        > be recovered.**

        > Run the following command where `kubectl` is installed and with the
        > context set for your Kubernetes cluster.

        ```bash
        $ curl -s {{% baseurl %}}/sh/permanently-delete-storageos-data.sh | bash
        ```

1. Flush Etcd Data

    **This will remove any keys written by Ondat.**

    ```bash
    $ export ETCDCTL_API=3
    $ etcdctl --endpoints=http://$ETCD_IP:2379 del --prefix "storageos"
    ```

    If running Etcd with mTLS, you can set the certificates location with the
    following command.

    ```bash
    $ export ETCDCTL_API=3
    $ etcdctl --endpoints=https://$ETCD_IP:2379 \
            --cacert=/path/to/ca.pem          \
            --cert=/path/to/client-cert.pem   \
            --key=/path/to/client-key.pem     \
            del --prefix "storageos"
    ```
