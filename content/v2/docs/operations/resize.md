---
title: Volume Resize
---

Ondat supports offline resize of volumes through editing a PVC storage
request, or by updating the volume config via the CLI or UI. This means that a
volume cannot be resized while it is in use. Furthermore, in order for a resize
operation to take place the volume must not be attached to a node. This is to
ensure the volume is not in use. Please note that Ondat only supports
increasing volume size. For more information about how the resize works please
see our [Resize concepts](/docs/concepts/volumes#volume-resize) page.

### Resizing a Volume

In order to resize a PVC the storage request field must be updated.

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-1
spec:
  storageClassName: fast
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
```

In order to edit a PVC you can use `kubectl edit` or `kubectl apply` to make
changes.

Ondat supports offline resize of volumes through editing a PVC storage
request. This means that a volume cannot be resized while it is in use.
Furthermore, in order for a resize operation to take place the volume must not
be attached to a node. This requires that any pods using a volume must be
scaled down for the resize to take place.


> N.B. Resizing a volume without updating the PVC directly will NOT result in
> the PVC being updated. The methods below are included for completeness, in
> Kubernetes environments editing the PVC is the preferred method for resizing
> a volume.

To resize a volume using the Ondat CLI use the `volume update` command

```bash
$ storageos update volume size pvc-a47cfa03-cc92-4ec9-84ab-00e5516c64fa 10GiB
Name:                                 pvc-a47cfa03-cc92-4ec9-84ab-00e5516c64fa
ID:                                   925e667f-91d3-465a-9391-8fdb56d0c9ff
Size:                                 10 GiB
Description:
AttachedOn:
Replicas:                             1x ready
Labels:
  - csi.storage.k8s.io/pv/name        pvc-a47cfa03-cc92-4ec9-84ab-00e5516c64fa
  - csi.storage.k8s.io/pvc/name       pvc-1
  - csi.storage.k8s.io/pvc/namespace  default
  - pool                              default
  - storageos.com/replicas            1

Volume pvc-a47cfa03-cc92-4ec9-84ab-00e5516c64fa (925e667f-91d3-465a-9391-8fdb56d0c9ff) updated. Size changed.
```

To resize a volume using the Ondat UI, navigate to the volumes section and
click the edit pencil in order to update the volume config.

![Ondat Resize](/images/docs/operations/resize/resize-vol.png)
