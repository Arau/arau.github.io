---
linkTitle: StorageClasses
title: Kubernetes StorageClasses
---

[StorageClasses](https://kubernetes.io/docs/concepts/storage/storage-classes/)
in Kubernetes are used to link PVCs with a backend storage provisioner - for
instance, Ondat. A StorageClass defines parameters to pass to the
provisioner, which in the case of Ondat can be translated into behaviour
applied to the Volumes. Many StorageClasses can be provisioned to apply
different feature labels to the Ondat Volumes.

By default the Ondat Cluster Operator installs the `fast` StorageClass at
bootstrap of Ondat. You can define its name in the Ondat Cluster
Resource.

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast
  labels:
    app: storageos
provisioner: csi.storageos.com # CSI Driver
allowVolumeExpansion: true
parameters:
  csi.storage.k8s.io/fstype: ext4

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

StorageClasses can be created to define default labels for Ondat volumes,
but also to map to any semantic aggregation of volumes that suits your use
case, whether there are different roles (dev, staging, prod), or a
StorageClass maps to a team or customer using the cluster.

## Examples

You can find the basic examples in the Ondat use-cases repository, in
the `00-basic` directory.

```bash
git clone https://github.com/storageos/use-cases.git storageos-usecases
cd storageos-usecases/00-basic
```

StorageClass definition in `v2-storageclass-replicated.yaml`.

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ondat-replicated
provisioner: csi.storageos.com # CSI Driver
allowVolumeExpansion: true
parameters:
  csi.storage.k8s.io/fstype: ext4
  storageos.com/replicas: "1" # Enforces 1 replica for the Volume

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


That StorageClass can be used by a PVC:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-vol-1
spec:
  storageClassName: "ondat-replicated" # Ondat StorageClass
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
```

The above StorageClass has the `storageos.com/replicas` label set. This
label tells Ondat to create a volume with a replica. Adding Ondat
feature labels to the StorageClass ensures all volumes created with the
StorageClass have the same labels.

You can also choose to add the label in the PVC definition rather than the
StorageClass. The PVC definition takes precedence over the SC.
