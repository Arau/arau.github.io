---
title: "Prerequisites"
linkTitle: "Prerequisites"
weight: 300
aliases:
  - /docs/install/prerequisites/clusterdiscovery
description: >
  Ondat requirements to be executed. Hardware, Network rules, Operative
  System Distribution, Kernel modules, etc.
---

## Minimum requirements:

One machine with the following:

1. Minimum two core with 4GB RAM.
1. Linux with a 64-bit architecture.
1. Container Runtime Engine: CRI-O, Containerd or Docker 1.10+ with [mount propagation]({{< ref "docs/prerequisites/mountpropagation.md" >}}) enabled.
1. The necessary ports should be open. See the [ports and firewall settings]({{< ref "docs/prerequisites/firewalls.md" >}}).
1. A mechanism for [device presentation]({{< ref "docs/prerequisites/systemconfiguration.md" >}}).

## Recommended:

1. At least three nodes for replication and high availability.
1. [Install the storageos CLI]({{< ref "docs/reference/cli/_index.md" >}}).
1. If using Helm, make sure the tiller ServiceAccount has enough privileges to
   create resources such as Namespaces, ClusterRoles, etc. For instance, following this [installation
   procedure](https://github.com/helm/helm/blob/master/docs/rbac.md#example-service-account-with-cluster-admin-role).
1. System clocks synchronized using NTP or similar methods. While our
   distributed consensus algorithm does not require synchronised clocks, it
   does help to more easily correlate logs across multiple nodes.
