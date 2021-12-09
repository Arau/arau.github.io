---
title: Upgrading Ondat version
linkTitle: Upgrade Ondat
---


> Before upgrading, check the 
> [release notes]({{< ref "docs/reference/release_notes.md" >}}) to confirm
> whether there is a safe upgrade path between versions.

Ondat version upgrades must be planned and executed taking into consideration
that volumes will be inaccessible during the process. It is recommended to
schedule a maintenance window.

Currently there are two strategies to upgrade Ondat and both maintain data
integrity during the upgrade process. Ondat keeps the data on the hosts
where the Ondat container is running. When the new version of Ondat starts,
the volumes from the previous version are available.

1. Full stop of the cluster
1. Rolling upgrade

> More upgrade procedures will be released that will automate the main part of
> the process and fulfil use cases not covered currently.

> The [CLI]({{< ref "docs/reference/cli/_index.md" >}}) is required to perform an upgrade.

## Option 1. Full stop of the cluster

This option consists of downscaling all applications using Ondat volumes to
0, stopping all Ondat pods, starting Ondat with a
new version and rescaling applications to previous size. Deployments that don't
use Ondat volumes remain unaffected.

This option does not require moving data across nodes, therefore it is
recommended for clusters with large data sets. However, __it implies downtime__ for
stateful applications.

Execute the following instructions:

Prepare upgrade:

1. Prepare an etcd backup if using external etcd.
1. Optionally make sure all nodes have the new Ondat image pulled, so the new
   containers will start promptly.
    ```bash
    docker pull storageos/node:$NEW_VERSION
    ```
1. Downscale any applications using Ondat volumes to 0.

    > Any mount points will hang while Ondat Pods are not present if the
    > application Pods haven't been stopped. A restart of the Pods mounting
    > volumes will be necessary if they are not stopped before hand.

1. Put the Ondat cluster in
   [maintenance](/docs/operations/maintenance#cluster-maintenance-mode) mode.

    Ondat implements a maintenance mode that freezes the cluster. When in
    maintenance mode, Ondat operations are limited. Functionalities such as
    volume provisioning, failover of primary volumes or managing nodes are
    disabled.
1. Execute the Ondat Upgrade cluster helper
    ```bash
    curl -Ls https://raw.githubusercontent.com/storageos/deploy/master/k8s/deploy-storageos/upgrade-helper/prepare-upgrade.sh -o prepare-upgrade.sh
    chmod +x ./prepare-upgrade.sh
    ./prepare-upgrade.sh
    ```

    > The upgrade helper patches the Ondat DaemonSet and sets the latest
    > version of the containers among other tasks.

    > The `prepare-upgrade.sh` script can be executed as many times as needed
    > to verify that your cluster is ready to be upgraded.


1. Delete Ondat Pods.

    ```bash
   kubectl -n $NAMESPACE delete pods --selector app=storageos,kind=daemonset
    ```

1. Check that Ondat is starting and wait until the Pods are in `ready` state.

    ```bash
   kubectl -n $NAMESPACE get pods
    ```

1. Take the Ondat cluster out of [maintenance
   mode](/docs/operations/maintenance#cluster-maintenance-mode).
1. Scale up applications that were using Ondat volumes, once Ondat is
   up and running.


## Option 2. Manual rolling upgrade


This option consists of moving stateful applications and Ondat volumes from
a node, applying the version upgrade and repeating this process for every node.
Only Pods using Ondat nodes will need to be evicted.

This option requires the promotion of replicas and data to be rebuilt on new nodes
at least once per volume. It is possible to wait for volumes without replicas
to be evicted from a node, however we recommend that a replica is created as per
the steps below. Please note that it is recommended to create at least one replica
per node for the purpose of the upgrade.

Clusters with large data sets or a large number nodes might take a long time to
finish the procedure.

This procedure requires __a restart of the stateful pods__ at least twice during
the procedure.

The amount of nodes you can upgrade at the same time will depend on the amount
of replicas the volumes have. With 2 replicas per volume, it is possible to
upgrade 2 nodes at a time without causing unavailability of data apart from
the application stop/start. It is recommended to upgrade one node at a time.

Execute the following instructions:

Prepare upgrade:

1. Prepare an etcd backup if using external etcd.
1. Make sure all nodes have the new Ondat image pulled, so the new
   containers will start promptly (optional).
   ```bash
   docker pull storageos/node:$NEW_VERSION
   ```

1. Make sure that all volumes have at least one replica

    ```bash
    # Save what volumes had 0 replicas to restore to that state later
    $ storageos volume ls --format "table {{.Name}}\t{{.Replicas}}"  \
        | grep '0/0' \
        | awk '{ print $1  }' \
        > /var/tmp/volume-0-replicas.txt

    # Update volumes to enable 1 replica
    $ storageos volume ls --format "table {{.Name}}\t{{.Replicas}}" \
        | grep '0/0' \
        | awk '{ print $1  }' \
        | xargs -I{} storageos volume update --label-add storageos.com/replicas=1 {}
    ```

1. Wait until all replicas are synced (1/1)

    ```bash
    $ storageos volume ls --format "table {{.Name}}\t{{.Replicas}}" 
    NAMESPACE/NAME                                      REPLICAS
    default/pvc-166ba271-e75c-11e8-8a20-0683b54ab438    0/1
    mysql/pvc-2b38b2e2-e75c-11e8-8a20-0683b54ab438      0/1
    postgress/pvc-3b39f530-e75c-11e8-8a20-0683b54ab438  0/1
    redis/pvc-8b8b37eb-e75d-11e8-8a20-0683b54ab438      0/1
    (...)

    $ storageos volume ls --format "table {{.Name}}\t{{.Replicas}}" 
    NAMESPACE/NAME                                      REPLICAS
    default/pvc-166ba271-e75c-11e8-8a20-0683b54ab438    1/1
    mysql/pvc-2b38b2e2-e75c-11e8-8a20-0683b54ab438      1/1
    postgress/pvc-3b39f530-e75c-11e8-8a20-0683b54ab438  1/1
    redis/pvc-8b8b37eb-e75d-11e8-8a20-0683b54ab438      1/1
    ```

Execute the upgrade:
1. Execute the Ondat Upgrade cluster helper
    ```bash
    curl -Ls https://raw.githubusercontent.com/storageos/deploy/master/k8s/deploy-storageos/upgrade-helper/prepare-upgrade.sh -o prepare-upgrade.sh
    chmod +x ./prepare-upgrade.sh
    ./prepare-upgrade.sh
    ```

    > The upgrade helper patches the Ondat DaemonSet and sets the latest
    > version of the containers among other tasks.

    > The `prepare-upgrade.sh` script can be executed as many times as needed
    > to verify that your cluster is ready to be upgraded.

1. Cordon and drain node

    ```bash
   # Select what node is being manipulated 
   export NODE=node01 # Define your node
   storageos node cordon $NODE
   storageos node drain $NODE
   kubectl cordon $NODE
   kubectl drain --ignore-daemonsets $NODE
    ```
    > If there are many Pods running stateless applications that don't need to
    > be evicted, you can delete the stateful Pods after the `kubectl cordon
    > $NODE` so they start in a different node and omit the `kubectl drain
    > $NODE`

1. Delete Ondat Pod.

    ```bash
   kubectl -n $NAMESPACE get pod -owide --no-headers | grep "$NODE" | awk '{print $1}' | xargs -I{} kubectl -n $NAMESPACE delete pod {}
    ```

1. Wait until Ondat Pod with the new version is started and ready.

    ```bash
   $ kubectl -n $NAMESPACE get pod -owide --no-headers | grep "$NODE" | awk '{print $1}' | xargs -I{} kubectl -n $NAMESPACE get pod {}
    NAME              READY     STATUS    RESTARTS   AGE
    storageos-j7pqf   1/1       Running   0          3m
    ```

1. Uncordon node

    ```bash
   storageos node uncordon $NODE
   storageos node undrain $NODE
   kubectl uncordon $NODE
    ```
1. Repeat from point 2 for every node of the cluster

> Once you are finished with all nodes, remove the replicas of the volumes that
> didn't have them on the first place.

```bash
while read vol; do
  storageos volume update --label-add storageos.com/replicas=0 $vol
done </var/tmp/volume-0-replicas.txt
```
