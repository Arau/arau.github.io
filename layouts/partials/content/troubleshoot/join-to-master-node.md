## Peer discovery - Pod allocation

### Issue:
Ondat nodes can't join the cluster and show the following log entries.

```bash
time="2018-09-24T13:40:20Z" level=info msg="not first cluster node, joining first node" action=create address=172.28.128.5 category=etcd host=node3 module=cp target=172.28.128.6
time="2018-09-24T13:40:20Z" level=error msg="could not retrieve cluster config from api" status_code=503
time="2018-09-24T13:40:20Z" level=error msg="failed to join existing cluster" action=create category=etcd endpoint="172.28.128.3,172.28.128.4,172.28.128.5,172.28.128.6" error="503 Service Unavailable" module=cp
time="2018-09-24T13:40:20Z" level=info msg="retrying cluster join in 5 seconds..." action=create category=etcd module=cp
```

### Reason:
Ondat uses a gossip protocol to discover the nodes in the cluster. When
Ondat starts, one or more active nodes must be referenced so new nodes can
query existing nodes for the list of members. This error indicates that the node
can't connect to any of the nodes in the known list. The known list is defined
in the `JOIN` variable.

If there are no active Ondat nodes, the bootstrap process will elect the
first node in the `JOIN` variable as master, and the rest will try to
discover from it. In case of that node not starting, the whole cluster will
remain unable to bootstrap.

Installations of Ondat use a DaemonSet, and by default do not schedule
Ondat pods to master nodes, due to the presence of the
`node-role.kubernetes.io/master:NoSchedule` taint that is typically present. In
such cases the `JOIN` variable must not contain master nodes or the Ondat
cluster will remain unable to start.

### Assert:

Check that the first node of the `JOIN` variable started properly.

```bash
root@node1:~/# kubectl -n kube-system describe ds/storageos | grep JOIN
    JOIN:          172.28.128.3,172.28.128.4,172.28.128.5
root@node1:~/# kubectl -n kube-system get pod -o wide | grep 172.28.128.3
storageos-8zqxl   1/1       Running   0          2m        172.28.128.3   node1
```

### Solution:

Make sure that the `JOIN` variable doesn't specify the master nodes. In case
you are using the discovery service, it is necessary to ensure that the
DaemonSet won't allocate Pods on the masters. This can be achieved with taints,
node selectors or labels.

For installations with the Ondat operator you can specify which nodes to
deploy Ondat on using nodeSelectors. See examples in the [Cluster Operator
Examples
page](docs/reference/cluster-operator/examples/#installing-to-a-subset-of-nodes).

For more advanced installations using compute-only and storage nodes, check the
`storageos.com/deployment=computeonly` label that can be added to the nodes
through Kubernetes node labels, or Ondat in the [Labels](
{{ ref . "docs/reference/labels.md" }}) page.
