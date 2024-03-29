## 0/0 Pods in DaemonSet

### Issue:

Ondat pods not being scheduled and no error is shown in the DS.
```bash
kubectl -n kube-system get daemonset
NAME                  DESIRED   CURRENT   READY     UP-TO-DATE   AVAILABLE NODE SELECTOR   AGE
storageos-daemonset   0         0         0         0            0         <none>          5s
```

### Reason:
This indicates that no node in the cluster was selected by the Operator to
deploy Ondat.

### Assert
Check the NodeSelector section of the CustomResource.

```bash
kubectl -n default describe stos storageos

...

Node Selector Terms:
Match Expressions:
  Key:       node-role.kubernetes.io/worker
  Operator:  In
  Values:
    wrongValue <-- No node in the cluster has this label
...
```

Query the nodes based on that NodeSelectorSpec.

```bash
kubectl get nodes -l node-role.kubernetes.io/worker=wrongValue
# Empty output --> No nodes match
```

> Where the CustomResource name is "storageos"

Because the NodeSelector Expression doesn't match with the node label,
Ondat doesn't have candidate nodes where to locate the Pods started by the
"storageos-daemonset".

### Solution:

Check the label `node-role.kubernetes.io/` in your cluster's nodes to ensure the right
NodeSelector.

```bash
kubectl get nodes --show-labels
node1   Ready     compute   1d        v1.11.5   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/hostname=node1,node-role.kubernetes.io/worker=true
node2   Ready     compute   1d        v1.11.5   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/hostname=node2,node-role.kubernetes.io/worker=true
node3   Ready     compute   1d        v1.11.5   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/hostname=node3,node-role.kubernetes.io/worker=true
```

Delete the `stos` Custom Resource. 

> **Warning:** This will delete all Ondat Pods. Therefore, the data will be inaccessible
> until you restart the Ondat cluster and the application Pods mounting
> Ondat volumes.

```bash
kubectl -n default delete stos storageos
```

Create the Custom Resource using the appropriate NodeSelector for
compute/worker nodes following the [example](/docs/reference/cluster-operator#installing-to-a-subset-of-nodes).
