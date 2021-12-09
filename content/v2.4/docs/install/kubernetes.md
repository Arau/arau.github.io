---
title: Kubernetes
weight: 1
aliases:
  - /install/kubernetes/
  - /install/aks/
  - /install/eks/
  - /install/dockeree/
  - /install/gke/
  - /docs/install/schedulers/kubernetes/
  - /docs/install/kubernetes/
  - /docs/install/kubernetes/install/
  - /docs/install/aks/
  - /docs/install/eks/
  - /docs/install/gke/
  - /docs/install/dockeree/
  - /docs/platforms/kubernetes/install/
  - /docs/platforms/kubernetes/install/1.17/
  - /docs/platforms/kubernetes/install/1.16/
  - /docs/platforms/kubernetes/install/1.15/
  - /docs/platforms/kubernetes/install/1.14/
  - /docs/platforms/azure-aks/install/
  - /docs/platforms/azure-aks/install/
  - /docs/platforms/aws-eks/install/
  - /docs/platforms/aws-eks/install/install/
  - /docs/platforms/dockeree/install/
  - /docs/platforms/dockeree/install/kubernetes/
---

> Make sure the
> [prerequisites for Ondat]({{< ref "docs/prerequisites/_index.md" >}}) are
> satisfied before proceeding.

> Any Kubernetes managed service such as EKS, AKS, GKE, DO or DockerEE
> platform can use the following Kubernetes guide to install Ondat.

> Ondat supports the five most recent Kubernetes releases, at minimum.

> Make sure to add a Ondat licence after installing.

&nbsp;

{{< tabs tabTotal="6" tabID="1" tabHREFPrefix="k8s-" tabName1="1.21" tabName2="1.20" tabName3="1.19" tabName4="1.18" tabName5="1.17">}}
{{% tab firstTab="true" tabRef="k8s-121" %}}

# Install Ondat on Kubernetes 1.21

{{% operator-header %}}
{{% operator-install cmd="kubectl" %}}
{{% operator-secret storageos_version="2" %}}
{{% operator-cr-v2 cmd="kubectl" sched_version="1.21" platforms="upstream,eks,aks,gke" %}}
{{% license-cluster %}}
{{% /tab %}}

{{% tab tabRef="k8s-120" %}}

# Install Ondat on Kubernetes 1.20

{{% operator-header %}}
{{% operator-install cmd="kubectl" %}}
{{% operator-secret storageos_version="2" %}}
{{% operator-cr-v2 cmd="kubectl" sched_version="1.20" platforms="upstream,eks,aks,gke" %}}
{{% license-cluster %}}
{{% /tab %}}
{{% tab tabRef="k8s-119" %}}
# Install Ondat on Kubernetes 1.19

{{% operator-header %}}
{{% operator-install cmd="kubectl" %}}
{{% operator-secret storageos_version="2" %}}
{{% operator-cr-v2 cmd="kubectl" sched_version="1.19" platforms="upstream,eks,aks,gke" %}}
{{% license-cluster %}}
{{% /tab %}}

{{% tab tabRef="k8s-118" %}}
# Install Ondat on Kubernetes 1.18

{{% operator-header %}}
{{% operator-install cmd="kubectl" %}}
{{% operator-secret storageos_version="2" %}}
{{% operator-cr-v2 cmd="kubectl" sched_version="1.18" platforms="upstream,eks,aks,gke" %}}
{{% license-cluster %}}
{{% /tab %}}

{{% tab tabRef="k8s-117" %}}
# Install Ondat on Kubernetes 1.17

{{% operator-header %}}
{{% operator-install cmd="kubectl" %}}
{{% operator-secret storageos_version="2" %}}
{{% operator-cr-v2 cmd="kubectl" sched_version="1.17" platforms="upstream,eks,aks,gke" %}}
{{% license-cluster %}}

{{% /tab %}}
{{< /tabs >}}

{{% include "content/first-volume.md" %}}
