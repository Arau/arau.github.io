---
title: Cluster health
linkTitle: Health
---

Various tools are available for checking on the status of a cluster.

The [CLI]({{< ref "docs/reference/cli/_index.md" >}}) displays the
status of nodes in the cluster.

```bash
$ storageos get nodes
NAME        HEALTH  AGE             LABELS
node1       online  44 minutes ago
node2       online  44 minutes ago
node3       online  44 minutes ago
node4       online  44 minutes ago
node5       online  44 minutes ago
```
