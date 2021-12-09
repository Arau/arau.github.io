---
title: OpenShift
---

OpenShift and Ondat communicate with each other to perform actions such as
creation, deletion and mounting of volumes. The standard communication procedure in
OpenShift versions 3.x uses REST API calls. However, Ondat also implements
communication using CSI. When using CSI, OpenShift and Ondat communicate via
a Linux socket. This socket is created and handled by the Kubelet on the host.

OpenShift v4 uses CSI by default.

## CSI (Container Storage Interface) Note

CSI is the standard that enables storage drivers to release on their own
schedule. This allows storage vendors to upgrade, update, and enhance their
drivers without the need to update Kubernetes source code, or follow Kubernetes
release cycles.

CSI is in "Technology Preview and not for production workloads" in OpenShift
3.11. **Ondat recommends the use of CSI for OpenShift v4, as CSI is
generally available in Openshift v4**

## Ondat PersistentVolumeClaims

The user can provide standard PVC definitions and Ondat will dynamically
provision them. Ondat presents volumes to containers with standard POSIX
mount targets. This enables the Kubelet to mount Ondat volumes using
standard linux device files. Checkout [device presentation]({{< ref
"docs/prerequisites/systemconfiguration.md" >}}) for more details.

## Installation

Ondat supports OpenShift 3.9, 3.10, 3.11, 4.1, 4.2 and 4.3.

To install Ondat on OpenShift, please follow our [installation
instructions]({{< ref "docs/install/openshift.md">}}) page.
