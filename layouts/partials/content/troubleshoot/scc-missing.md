## (OpenShift) Ondat pods missing -- DaemonSet error

Ondat DaemonSet doesn't have any pod replicas. The DaemonSet couldn't
allocate any Pod due to security issues.

### Issue:
```bash
[root@master02 standard]# oc get pod
No resources found.
[root@master02 standard]# oc describe daemonset storageos
(...)
Events:
  Type     Reason        Age                From                  Message
  ----     ------        ----               ----                  -------
  Warning  FailedCreate  0s (x12 over 10s)  daemonset-controller  Error creating: pods "storageos-" is forbidden: unable to validate against any security context constraint: [provider restricted: .spec.securityContext.hostNetwork: Invalid value: true: Host network is not allowed to be used provider restricted: .spec.securityContext.hostPID: Invalid value: true: Host PID is not allowed to be used spec.volumes[0]: Invalid value: "hostPath": hostPath volumes are not allowed to be used spec.volumes[1]: Invalid value: "hostPath": hostPath volumes are not allowed to be used spec.volumes[2]: Invalid value: "hostPath": hostPath volumes are not allowed to be used spec.volumes[3]: Invalid value: "hostPath": hostPath volumes are not allowed to be used spec.initContainers[0].securityContext.privileged: Invalid value: true: Privileged containers are not allowed capabilities.add: Invalid value: "SYS_ADMIN": capability may not be added spec.initContainers[0].securityContext.hostNetwork: Invalid value: true: Host network is not allowed to be used spec.initContainers[0].securityContext.containers[0].hostPort: Invalid value: 5705: Host ports are not allowed to be used spec.initContainers[0].securityContext.hostPID: Invalid value: true: Host PID is not allowed to be used spec.containers[0].securityContext.privileged: Invalid value: true: Privileged containers are not allowed capabilities.add: Invalid value: "SYS_ADMIN": capability may not be added spec.containers[0].securityContext.hostNetwork: Invalid value: true: Host network is not allowed to be used spec.containers[0].securityContext.containers[0].hostPort: Invalid value: 5705: Host ports are not allowed to be used spec.containers[0].securityContext.hostPID: Invalid value: true: Host PID is not allowed to be used]
```

### Reason:

The OpenShift cluster has security context constraint policies enabled that
forbid any pod, without an explicitly set policy for the service account, to
be allocated.

### Assert:

Check if the Ondat ServiceAccount can create pods with enough permissions
```bash
oc get scc privileged -o yaml # Or custom scc with enough privileges
(...)
users:
- system:admin
- system:serviceaccount:openshift-infra:build-controller
- system:serviceaccount:management-infra:management-admin
- system:serviceaccount:management-infra:inspector-admin
- system:serviceaccount:storageos:storageos                       <--
- system:serviceaccount:tiller:tiller
```

If the Ondat sa system:serviceaccount:storageos:storageos is in the
privileged scc it will be able to create pods.

### Solution:

Add the ServiceAccount system:serviceaccount:storageos:storageos to a scc with
enough privileges.

```bash
oc adm policy add-scc-to-user privileged system:serviceaccount:storageos:storageos
```
