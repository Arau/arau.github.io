## PVC pending state - Secret Missing

A created PVC remains in pending state making pods that need to mount that PVC
unable to start.

### Issue: 
```bash
kubectl describe pvc $PVC
(...)
Events:
  Type     Reason              Age                From                         Message
  ----     ------              ----               ----                         -------
  Warning  ProvisioningFailed  13s (x2 over 28s)  persistentvolume-controller  Failed to provision volume with StorageClass "storageos": failed to get secret from ["storageos"/"storageos-api"]

```

### Reason:
For non CSI installations of Ondat, Kubernetes uses the Ondat
API endpoint to communicate. If that communication fails, relevant actions such
as create or mount a volume can't be transmitted to Ondat, and the PVC
will remain in pending state. Ondat never received the action to perform,
so it never sent back an acknowledgement.

The StorageClass provisioned for Ondat references a Secret from where it
retrieves the API endpoint and the authentication parameters. If that secret is
incorrect or missing, the connections won't be established. It is common to see
that the Secret has been deployed in a different namespace where the
StorageClass expects it or that is has been deployed with a different name.

### Assert:

1. Check the StorageClass parameters to know where the Secret is expected to be found.

    ```bash
    $ kubectl get storageclass storageos -o yaml

    apiVersion: storage.k8s.io/v1
    kind: StorageClass
    metadata:
      name: storageos
    provisioner: csi.storageos.com
    allowVolumeExpansion: true
    parameters:
      csi.storage.k8s.io/fstype: ext4
      storageos.com/replicas: "1"
      csi.storage.k8s.io/secret-name: storageos-api
      csi.storage.k8s.io/secret-namespace: storageos
    ```

    > Note that the parameters specify `secret-namespace` and `secret-name`.

1. Check if the secret exists according to those parameters
    ```bash
    kubectl -n storageos get secret storageos-api
    No resources found.
    Error from server (NotFound): secrets "storageos-api" not found
    ```

    If no resources are found, it is clear that the Secret doesn't exist or it is not deployed in
    the right location.

### Solution:
Deploy Ondat following the [installation procedures](
{{ ref . "docs/introduction/quickstart.md" }}). If you are using the manifests
provided for Kubernetes to deploy Ondat rather than using automated
provisioners, make sure that the StorageClass parameters and the Secret
reference match.
