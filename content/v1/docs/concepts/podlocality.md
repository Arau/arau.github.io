---
linkTitle: Podlocality
title: Pod Placement
---

Ondat has the capacity to influence Kubernetes Pod placement decisions to
ensure that Pods are scheduled on the same nodes as their data. This
functionality is known as `Pod Locality`.

Ondat grants access to data by presenting, on local or remote nodes, the
devices used in a Pod's VolumeMounts. However, it is often the case that it is
required or preferred to place the Pod on the node where the Ondat Primary
Volume is located, because IO operations are fastest as a result of minimized
network traffic and associated latency. Read operations are served locally and
writes require fewer round trips to the replicas of the volume.

Ondat automatically enables the use of a custom scheduler for any Pod
using Ondat Volumes. Checkout the [Admission Controller reference](
{{< ref "docs/reference/scheduler/admission-controller.md" >}}) for more
information.

{{% include "content/scheduler/locality-modes.md" %}}

To see examples on how to set a mode for your Pods, check out the [examples
reference page]({{< ref "docs/reference/scheduler/examples.md" >}}).

{{% include "content/scheduler/sched-concepts.md" %}}

## Admission Controller

Ondat implements an [admission
controller](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#what-are-they)
that ensures any Pod using Ondat Volumes are scheduled by the Ondat
Scheduler. This makes the use of the scheduler transparent to the user. To learn how to alter this behaviour, see
 [reference page]({{< ref "docs/reference/scheduler/admission-controller.md" >}}).

The Admission Controller is based on admission webhooks. Therefore, no custom
admission plugins need to be enabled at bootstrap of your Kubernetes cluster.
Admission webhooks are HTTP callbacks that receive admission requests and do
something with them. The Ondat Cluster Operator serves the admission
webhook. So when a Pod is in the process of being created, the Ondat
Cluster Operator mutates the `spec.schedulerName` ensuring the
`storageos-scheduler` is set.
