---
title: Kubernetes
weight: 1
---

> Make sure the
> [prerequisites for Ondat]({{< ref "docs/prerequisites/_index.md" >}}) are
> satisfied before proceeding.

> Any Kubernetes managed service such as EKS, AKS, GKE, DO or DockerEE
> platform can use the following Kubernetes guide to install Ondat.

> Ondat supports the five most recent Kubernetes releases, at minimum.

> Make sure to add a Ondat licence after installing.

&nbsp;

{{< tabs tabTotal="6" tabID="1" tabHREFPrefix="k8s-" tabName1="1.20" tabName2="1.19" tabName3="1.18" tabName4="1.17" tabName5="1.16" tabName6="1.15" >}}
{{% tab firstTab="true" tabRef="k8s-120" %}}

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
{{% tab tabRef="k8s-116" %}}

# Install Ondat on Kubernetes 1.16

{{% operator-header %}}
{{% operator-install cmd="kubectl" %}}
{{% operator-secret storageos_version="2" %}}
{{% operator-cr-v2 cmd="kubectl" sched_version="1.16" platforms="upstream,eks,aks,gke" %}}
{{% license-cluster %}}

{{% /tab %}}
{{% tab tabRef="k8s-115" %}}

# Install Ondat on Kubernetes 1.15

{{% operator-header %}}
{{% operator-install cmd="kubectl" %}}
{{% operator-secret storageos_version="2" %}}
{{% operator-cr-v2 cmd="kubectl" sched_version="1.15" platforms="upstream,eks,aks,gke" %}}
{{% license-cluster %}}

{{% /tab %}}
{{< /tabs >}}

{{% include "content/first-volume.md" %}}
