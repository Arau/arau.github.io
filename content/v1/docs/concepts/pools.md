---
title: Pools
linkTitle: Pools
---


Ondat aggregates host storage from all nodes where the Ondat container
runs into a storage pool. A pool is a collection of storage based on host
attributes such as class of server, storage or location.

Node storage can be allocated to a specific pool using Node selectors. Pool node
selectors look for labels on host nodes and will aggregate storage from nodes
whose labels match into the specific pool.

Pools can have feature labels applied to them such as
`storageos.com/overcommit` which allows the pool to have its storage
[overcommited]({{< ref "docs/operations/overcommitment.md" >}}).
