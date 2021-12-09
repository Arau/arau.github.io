---
title: OpenShift
---

Ondat V2 supports Openshift v4.

OpenShift and Ondat communicate with each other to perform actions such as
creation, deletion and mounting of volumes through CSI. The CSI container
running in the Ondat Daemonset creates a Linux socket that allows the
communication between OpenShift and Ondat 

## CSI (Container Storage Interface) Note

CSI is the standard that enables storage drivers to release on their own
schedule. This allows storage vendors to upgrade, update, and enhance their
drivers without the need to update Kubernetes source code, or follow Kubernetes
release cycles.

Ondat v2 implements communication with the OpenShift controlplane with CSI
only. The native driver has been deprecated

## Ondat PersistentVolumeClaims

The user can provide standard PVC definitions and Ondat will dynamically
provision them. Ondat presents volumes to containers with standard POSIX
mount targets. This enables the Kubelet to mount Ondat volumes using
standard linux device files. Checkout [device presentation]({{< ref
"docs/prerequisites/systemconfiguration.md" >}}) for more details.

## Installation

Ondat v2 supports OpenShift 4.0, 4.1, 4.2 and 4.3.

To install Ondat on OpenShift, please follow our [installation
instructions]({{< ref "docs/install/openshift.md">}}) page.
