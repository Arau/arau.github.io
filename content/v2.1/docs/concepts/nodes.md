---
title: Nodes
linkTitle: Nodes
---

A Ondat node is any machine (virtual or physical) that is running the
Ondat daemonset pod. A node must be running a daemonset pod in order to
consume and/or present storage.

By default Ondat nodes run in `hyperconverged` mode. This means that the
node hosts data from Ondat volumes and can present volumes to applications.

Alternatively, a node can run in `computeonly` mode, which means no storage is
consumed on the node itself and the node only presents volumes hosted by
other nodes. Volumes presented to applications running on compute only nodes
are therefore all remote. Compute only nodes can be very useful for topologies
where nodes are ephemeral and should not host data, but the ephemeral nodes
host applications that require Ondat volumes. The nodes that are not
intended to hold data, but just to present Ondat volumes, can be set as
`computeonly`.

A node can be marked as compute only at any point in time by adding the label
`storageos.com/computeonly=true`, following the [labels reference](
{{< ref "docs/reference/labels.md" >}}).
