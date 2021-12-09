## PVC pending state - Failed to dial Ondat

A created PVC remains in pending state making pods that need to mount that PVC
unable to start.

### Issue:
```bash
root@node1:~/# kubectl get pvc
NAME      STATUS        VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
vol-1     Pending                                                                            storageos       7s

kubectl describe pvc $PVC
(...)
Events:
  Type     Reason              Age               From                         Message
  ----     ------              ----              ----                         -------
  Warning  ProvisioningFailed  7s (x2 over 18s)  persistentvolume-controller  Failed to provision volume with StorageClass "storageos": Get http://storageos-cluster/version: failed to dial all known cluster members, (10.233.59.206:5705)
```

### Reason:
For non CSI installations of Ondat, Kubernetes uses the Ondat
API endpoint to communicate. If that communication fails, relevant actions such
as create or mount volume can't be transmitted to Ondat, hence the PVC
will remain in pending state. Ondat never received the action to perform,
so it never sent back an acknowledgement.

In this case, the Event message indicates that Ondat API is not responding,
implying that Ondat is not running. For Kubernetes to define Ondat pods
ready, the health check must pass.

### Assert:

Check the status of Ondat pods.

```bash
root@node1:~/# kubectl -n kube-system get pod --selector app=storageos # for CSI add --selector kind=daemonset
NAME              READY     STATUS    RESTARTS   AGE
storageos-qrqkj   0/1       Running   0          1m
storageos-s4bfv   0/1       Running   0          1m
storageos-vcpfx   0/1       Running   0          1m
storageos-w98f5   0/1       Running   0          1m
```

If the pods are not READY, the service will not forward traffic to the API they
serve hence PVC will remain in pending state until Ondat pods are
available.

> Kubernetes keeps trying to execute the action until it succeeds. If
> a PVC is created before Ondat finish starting, the PVC will be created
> eventually.

### Solution:
- Ondat health check takes 60 seconds of grace before reporting as READY.
  If Ondat is starting properly after that period, the volume will be
  created when Ondat finishes its bootstrap.
- If Ondat is not running or is not starting properly, the solution would
  be to troubleshoot the installation.
