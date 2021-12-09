---
title: "Architecture"
linkTitle: "Architecture"
---

Ondat is a software-defined storage platform for running stateful
applications in Kubernetes.

Fundamentally, Ondat uses the storage attached to the nodes in the
Ondat cluster to create and present virtual volumes into containers. Space
on the host is consumed from the mount point `/var/lib/storageos/data`, so it
is therefore recommended that disk devices are used exclusively for Ondat,
as described in [Managing Host Storage ]({{< ref
"docs/operations/managing-host-storage.md" >}})

Ondat is agnostic to the underlying storage and runs equally well on
bare metal, in virtual machines or on cloud providers.

![Ondat architecture](/images/docs/concepts/storageos-cluster.png)

Read about [the cloud native storage principles behind
Ondat](https://storageos.com/storageos-cloud-native-storage).

### Ondat on Kubernetes

Ondat is architected as a series of containers that fulfil separate,
discrete functions.
* Ondat Controlplane

    Responsible for monitoring and maintaining the state of volumes and nodes in the cluster

* Ondat Dataplane

    Responsible for all I/O path related tasks; reading, writing, compression and caching

* Ondat Scheduler

    Responsible for scheduling applications on the same node as applications' volumes

* CSI helper

    Responsible for registering Ondat with Kubernetes as a CSI driver

* Ondat Operator

    Responsible for the creation and maintenance of the Ondat cluster


Ondat is deployed by the Ondat operator. In Kubernetes, the Ondat
Controlplane and Dataplane are deployed in a single pod managed by a daemonset.
This daemonset runs on every node in the cluster that will consume or present
storage. The scheduler, CSI helper and Operator run as separate pods and are
controlled as deployments.

Ondat is designed to feel familiar to Kubernetes and Docker users. Storage
is managed through standard StorageClasses and PersistentVolumeClaims, and
[features]({{< ref "docs/reference/labels.md" >}}) are controlled by
Kubernetes-style labels and selectors, prefixed with `storageos.com/`. By
default, volumes are cached to improve read performance and compressed to
reduce network traffic.

Any pod may mount a Ondat virtual volume from any node that is also
running Ondat, regardless of whether the pod and volume are
collocated on the same node. Therefore, applications may be started or
restarted on any node and access volumes transparently.




