---
title: Failure Modes
linkTitle: Failure Modes
---

For more information about replication and failure modes, see our
[Replication concepts page]({{< ref "docs/concepts/replication"
>}}).

The failure mode for a specific volume can be set using a label on a PVC or it
can be set as a parameter on a [StorageClass]({{< ref
"docs/operations/storageclasses" >}}). The PVC definition takes precedence over
the StorageClass.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-vol-1
  labels:
      storageos.com/replicas: "2"
      storageos.com/failure-mode: "soft"
spec:
  storageClassName: "storageos"
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
```


{{% include "content/failure-modes.md" %}}

