{{ $sched_version := .Get "sched_version" }}

The Ondat Cluster Operator is a [Kubernetes native
application](https://kubernetes.io/docs/concepts/extend-kubernetes/extend-cluster/)
developed to deploy and configure Ondat clusters, and assist with
maintenance operations. We recommend its use for standard installations.

The operator is a Kubernetes controller that watches the `StorageOSCluster`
CRD. Once the controller is ready, a Ondat cluster definition can be
created. The operator will deploy a Ondat cluster based on the
configuration specified in the cluster definition.

&nbsp;

**Helm Note:** If you want to use [Helm](https://helm.sh/docs/) to install Ondat, follow
the [Ondat Operator Helm
Chart](https://github.com/storageos/charts/tree/master/stable/storageos-operator#installing-the-chart)
documentation.


## __Steps to install Ondat:__

- [Install Ondat Operator](#1-install-storageos-operator)
- [Create a Secret for default username and password](#2-create-a-secret)
- [Trigger bootstrap using a CustomResource](#3-trigger-a-storageos-installation)
- [Apply Ondat licence](#4-license-cluster)
{{- if ge $sched_version 4.0 }}
- [Set SELinux Permissions](#4-set-selinux-permissions)
{{- end }}

