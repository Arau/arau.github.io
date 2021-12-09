---
linkTitle: DockerEE
title: Docker Enterprise Edition
---

To install Ondat on DockerEE, follow our Kubernetes [installation
instructions]({{< ref "docs/install/kubernetes.md">}}) page.

Docker EE and the Universal Control Plane can run on different Linux
distributions. Ondat supports RHEL, CentOS, Debian, and selected Ubuntu
images. For more details, check out the supported OSs in the
[prerequisites page]({{< ref "docs/prerequisites/systemconfiguration.md" >}}).

Ondat only supports Kubernetes nodes managed by Docker Enterprise Edition,
not those nodes running Swarm. Mixed nodes (those running Kubernetes and Swarm
workloads) are not supported. As a consequence, Ondat volumes can only be
provisioned on Kubernetes nodes, and only these nodes should be used for
stateful workloads.
