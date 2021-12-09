## Pod in pending because of mount error

### Issue:

The output of `kubectl describe pod $POD_ID` contains `no such file or
directory` and references the Ondat volume device file.

```bash
root@node1:~# kubectl -n kube-system describe $POD_ID
(...)
Events:
  (...)
  Normal   Scheduled         11s                default-scheduler  Successfully assigned default/d1 to node3
  Warning  FailedMount       4s (x4 over 9s)    kubelet, node3     MountVolume.SetUp failed for volume "pvc-f2a49198-c00c-11e8-ba01-0800278dc04d" : stat /var/lib/storageos/volumes/d9df3549-26c0-4cfc-62b4-724b443069a1: no such file or directory
```

### Reason:

There are two main reasons this issue may arise:
- The Ondat `DEVICE_DIR` location is wrongly configured when using Kubelet
  as a container
- Mount Propagation is not enabled


(Option 1) Misconfiguration of the DeviceDir/SharedDir

Some Kubernetes distributions such as Rancher, DockerEE or some installations
of OpenShift deploy the Kubelet as a container, because of this, the device
files that Ondat creates to mount into the containers need to be visible to
the kubelet. Ondat can be configured to share the device directory.

Modern installations use CSI, which handles the complexity internally.

### Assert:

```bash
root@node1:~# kubectl -n default describe stos | grep "Shared Dir"
  Shared Dir:      # <-- Shouldn't be blank
```

### Solution:

The Cluster Operator Custom Definition should specify the SharedDir option as follows.

```bash
spec:
  sharedDir: '/var/lib/kubelet/plugins/kubernetes.io~storageos' # Needed when Kubelet as a container
  ...
```

> See example on how to configure the [Ondat Custom
> Resource](/docs/reference/cluster-operator/examples/#specifying-a-shared-directory-for-use-with-kubelet-as-a-container).

&nbsp; <!-- this is a blank line -->

(Option 2) Mount propagation is not enabled.

> Applies only if Option 1 is configured properly.

### Assert:

**If not using the Kubelet as a container**, SSH into one of the nodes and check if
`/var/lib/storageos/volumes` is empty. If so, exec into any Ondat pod and
check the same directory.

```bash
root@node1:~# ls /var/lib/storageos/volumes/
root@node1:~#     # <-- Shouldn't be blank
root@node1:~# kubectl exec $POD_ID -c storageos -- ls -l /var/lib/storageos/volumes
bst-196004
d529b340-0189-15c7-f8f3-33bfc4cf03fa
ff537c5b-e295-e518-a340-0b6308b69f74
```

If the directory inside the container and the device files are visible,
disabled mount propagation is the cause.


**If using the Kubelet as a container**, SSH into one of the nodes and check if
`/var/lib/kubelet/plugins/kubernetes.io~storageos/devices` is empty. If
so, exec into any Ondat pod and check the same directory.

```bash
root@node1:~# ls /var/lib/kubelet/plugins/kubernetes.io~storageos/devices
root@node1:~#      # <-- Shouldn't be blank
root@node1:~# kubectl exec $POD_ID -c storageos -- ls -l /var/lib/kubelet/plugins/kubernetes.io~storageos/devices
bst-196004
d529b340-0189-15c7-f8f3-33bfc4cf03fa
ff537c5b-e295-e518-a340-0b6308b69f74
```

If the directory inside the container and the device files are visible,
disabled mount propagation is the cause.


### Solution:

Older versions of Kubernetes need to enable mount propagation as it is not
enabled by default. Most Kubernetes distributions allow MountPropagation to be
enabled using FeatureGates. Rancher specifically, needs to enable it in the
"View in API" section of your cluster. You need to edit the section
"rancherKubernetesEngineConfig" to enable the Kubelet feature gate.
