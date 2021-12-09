---
title: "Prerequisites"
linkTitle: "Prerequisites"
weight: 300
description: >
  Ondat requirements to be executed. Hardware, Network rules, Operative
  System Distribution, Kernel modules, etc.
---

## Minimum requirements:

One machine with the following:

1. Minimum two core with 4GB RAM.
1. Linux with a 64-bit architecture.
1. Kubernetes {{< param oldest_k8s_supported >}} to {{< param newest_k8s_supported >}}
1. Container Runtime Engine: CRI-O, Containerd or Docker 1.10+ with [mount propagation]({{< ref "docs/prerequisites/mountpropagation.md" >}}) enabled.
1. The necessary ports should be open. See the [ports and firewall settings]({{< ref "docs/prerequisites/firewalls.md" >}}).
1. [Etcd cluster]({{< ref "docs/prerequisites/etcd.md" >}}) for Ondat
1. A mechanism for [device presentation]({{< ref "docs/prerequisites/systemconfiguration.md" >}}).

## Recommended:

1. At least three nodes for replication and high availability.
1. Kubernetes {{< param oldest_k8s_supported >}} to {{< param newest_k8s_supported >}}
1. [Install the Ondat CLI]({{< ref "docs/reference/cli/_index.md" >}}).
1. If using Helm2, make sure the tiller ServiceAccount has enough privileges to
   create resources such as Namespaces, ClusterRoles, etc. For instance, following this [installation
   procedure](https://v2.helm.sh/docs/using_helm/#role-based-access-control).
1. System clocks synchronized using NTP or similar methods. While our
   distributed consensus algorithm does not require synchronised clocks, it
   does help to more easily correlate logs across multiple nodes.
1. A PID cgroup limit of 32768.
1. Some aspects of product operation require kernel support for IPv6. See the
   [IPv6 prequisites]({{< ref "docs/prerequisites/ipv6.md" >}}) page.
