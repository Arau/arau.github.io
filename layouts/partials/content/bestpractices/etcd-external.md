## Use an external Etcd cluster

Ondat uses the `etcd` distributed key-value store to store essential cluster
metadata and manage distributed configuration state. For production environments
and testing of production workloads, __we recommend deploying an external etcd
cluster.__ For more details about, and an example of, how to run etcd, see the
[External etcd Operations](/docs/operations/external-etcd) page.

It is highly recommended to use external etcd for __cloud environments__ and
place the etcd cluster on stable nodes. Placing the etcd on nodes that are
recycled often might affect the normal operations of Ondat.
