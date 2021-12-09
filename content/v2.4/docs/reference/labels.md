---
linkTitle: Labels
title: Ondat Feature Labels
aliases:
  - /openapi-help/labels # url referenced from UI
---

Feature labels are a powerful and flexible way to control storage features.

Applying specific feature labels triggers compression, replication and other
storage features. No feature labels are present by default.

## Ondat Node labels

Nodes do not have any feature labels present by default.  When Ondat is run
within Kubernetes, the Ondat API Manager syncs any Kubernetes node labels
to the corresponding Ondat node. The Kubernetes node labels act as the
"source of truth", so labels should be applied to the Kubernetes nodes rather
than to Ondat nodes. This is because the Kubernetes node labels overwrite
the Ondat node labels on sync.

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

Volumes do not have any feature labels present by default. 

>  WARNING: The encryption, caching and compression labels can only apply
>  at provisioning time, they can't be changed during execution.

| Feature             | Label                               | Values                                  | Description                                                                                                                                  |
| :------------------ | :---------------------------------- | :-----------------------------------    | :------------------------------------------------------------------------------------------------------------------------------------------- |
| Caching             | `storageos.com/nocache`             | true / false                            | Switches off caching.                                                                                                                        |
| Compression         | `storageos.com/nocompress`          | true / false                            | Switches off compression of data at rest and in transit (compression is not enabled by default to maximise performance).                                                                                     |
| Encryption          | `storageos.com/encryption`          | true / false                            | Encrypts the contents of the volume. For each volume, a key is automatically generated, stored, and linked with the PVC.                     |
| Failure Mode        | `storageos.com/failure-mode`        | hard, soft, alwayson or integers [0, 5] | Sets the failure mode for a volume, either explicitly using a failure mode or implicitly using a replica threshold.                          |
| Replication         | `storageos.com/replicas`            | integers [0, 5]                         | Sets the number of replicas i.e full copies of the data across nodes. Typically 1 or 2 replicas is sufficient (2 or 3 instances of the data); latency implications need to be assesed when using more than 2 replicas.  |

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
    # Change the NameSpace below if Ondat doesn't run in kube-system
    csi.storage.k8s.io/controller-expand-secret-name: csi-controller-expand-secret
    csi.storage.k8s.io/controller-publish-secret-name: csi-controller-publish-secret
    csi.storage.k8s.io/node-publish-secret-name: csi-node-publish-secret
    csi.storage.k8s.io/provisioner-secret-name: csi-provisioner-secret
    csi.storage.k8s.io/controller-expand-secret-namespace: kube-system   # NameSpace that runs Ondat Daemonset
    csi.storage.k8s.io/controller-publish-secret-namespace: kube-system  # NameSpace that runs Ondat Daemonset
    csi.storage.k8s.io/node-publish-secret-namespace: kube-system        # NameSpace that runs Ondat Daemonset
    csi.storage.k8s.io/provisioner-secret-namespace: kube-system         # NameSpace that runs Ondat Daemonset
    ```

> N.B. The Ondat API manager periodically syncs labels from Kubernetes PVCs
> to the corresponding Ondat volume. Therefore changes to Ondat volume
> labels should be made to the corresponding Kubernetes PVC rather than to the
> Ondat volume directly.

## Ondat Pod labels

| Feature        | Label                         | Values                               | Description                    |
| :------------- | :---------------------------- | :----------------------------------- | :----------------------------- |
| Pod fencing   | `storageos.com/fenced`         | true / false                         | Targets a pod to be fenced in case of node failure. (default: false) |

> For a pod to be fenced by Ondat, a few requirements described in the
> [Fencing Operations]({{< ref "docs/operations/fencing.md" >}}) page need to be fulfilled.

```bash
kubectl label pod $POD storageos.com/fenced=true
```

It is recommended to define the fenced label in the pod's manifest, i.e in the
Statefulset definitions. Statefulsets pass labels to their
VolumeClaimTemplates. You must set the label only at the
`spec.template.metadata.labels`. Otherwise, the Ondat volumes will fail to
provision as only special accepted labels can be passed to volumes.

```bash
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: my-statefulset
spec:
  selector:
    matchLabels: # <----- Note that the matchLabels don't have the fenced label
      env: prod
  serviceName: my-statefulset-svc
  replicas: 1
  template:
    metadata:
      labels:   # <----- Note that the fenced label IS PRESENT
        env: prod
        storageos.com/fenced: "true"
    spec:
      containers:
...
```
