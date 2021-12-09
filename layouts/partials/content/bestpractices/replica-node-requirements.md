## Maintain a sufficient number of nodes for replicas to be created

To ensure that a new replica can always be created, an additional node should
be available. To guarantee high availability, clusters using Volumes with 1
replica must have at least 3 storage nodes. When using Volumes with 2
replicas, at least 4 storage nodes, 3 replicas, 5 nodes, etc.

Minimum number of storage nodes = 1 (primary) + N (replicas) + 1

For more information, see the section on
[replication]({{ ref . "docs/concepts/replication.md#number-of-nodes" }}).

