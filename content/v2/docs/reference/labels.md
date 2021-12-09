---
linkTitle: Labels
title: Ondat Feature labels
aliases:
  - /openapi-help/labels # url referenced from UI
---

Feature labels are a powerful and flexible way to control storage features.

Labels can be applied to various Ondat artefacts. Applying specific feature
labels triggers compression, replication and other storage features. No feature
labels are present by default.

## Ondat Node labels

Nodes do not have any feature labels present by default.  When Ondat is run
within Kubernetes, the [Cluster Operator](
{{< ref "docs/reference/cluster-operator/_index.md" >}}) syncs any node labels
set on Kubernetes nodes within Ondat.  Node labels may also be set with the
CLI or UI.

| Feature        | Label                         | Values                               | Description                    |
| :------------- | :---------------------------- | :----------------------------------- | :----------------------------- |
| Compute only   | `storageos.com/computeonly`   | true / false                         | Specifies whether a node should be `computeonly` where it only acts as a client and does not host volume data locally, otherwise the node is hyperconverged (the default), where the node can operate in both client and server modes. |

You can set the computeonly label on the Kubernetes node and the label will be
sync'd to the Ondat node (labels take an eventual consistency
reconciliation time of ~1min).

```bash
kubectl label node $NODE storageos.com/computeonly=true
```


## Ondat Volume labels

Volumes do not have any feature labels present by default. WARNING: The caching 
and compression labels can only apply during provision time, they can't be 
changed during execution. 

| Feature             | Label                               | Values                               | Description                                                                                                                                  |
| :------------------ | :---------------------------------- | :----------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------- |
| Caching             | `storageos.com/nocache`             | true / false                         | Switches off caching.                                                                                                                        |
| Compression         | `storageos.com/nocompress`          | true / false                         | Switches off compression of data at rest and in transit.                                                                                 |
| Replication         | `storageos.com/replicas`            | integers [0, 5]                      | Replicates entire volume across nodes. Typically 1 replica is sufficient (2 copies of the data); more than 2 replicas is not recommended. Once applied, this setting can only be changed in the Ondat UI or CLI.   |

To create a volume with a feature label:

- Option 1: PVC Label

    Add the label in the PVC definition, for instance:

    ```yaml
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: pvc-3
      labels:
        storageos.com/replicas: "1" # Label <-----
    spec:
      storageClassName: "fast"
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 1G
    ```

- Option 2: Set label in the StorageClass

    Any PVC using the StorageClass inherits the label. The PVC label takes
    precedence over the StorageClass parameters.

    ```yaml
    apiVersion: storage.k8s.io/v1
    kind: StorageClass
    metadata:
      name: ondat-replicated
    parameters:
      csi.storage.k8s.io/fstype: ext4
      storageos.com/replicas: "1" # Label   <--------
    provisioner: storageos # CSI driver (recommended) 
    ```

- Option 3:

    Once a PVC is created, you can update the Labels in Ondat both in the
    UI or CLI. Those labels are going to be visible only for Ondat and will
    not be synced to the Kubernetes resource.
