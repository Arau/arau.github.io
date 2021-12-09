---
title: Kubernetes
weight: 1
---

> Make sure the 
> [prerequisites for Ondat]({{< ref "docs/prerequisites/_index.md" >}}) are
> satisfied before proceeding.

> Any Kubernetes managed service such as EKS, AKS, GKE, DO or DockerEE
> platform can use the following Kubernetes guide to install Ondat.

> **Ondat v2 uses CSI only. The native driver has been deprecated**.

> Make sure to add a Ondat licence after installing.

&nbsp;

{{< tabs tabTotal="5" tabID="1" tabHREFPrefix="k8s-" tabName1="1.17" tabName2="1.16" tabName3="1.15" tabName4="1.14" tabName5="1.13" >}}
{{% tab firstTab="true" tabRef="k8s-117" %}}

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
{{% tab tabRef="k8s-114" %}}

# Install Ondat on Kubernetes 1.14

{{% operator-header %}}
{{% operator-install cmd="kubectl" %}}
{{% operator-secret storageos_version="2" %}}
{{% operator-cr-v2 cmd="kubectl" sched_version="1.14" platforms="upstream,eks,aks,gke" %}}
{{% license-cluster %}}


{{% /tab %}}
{{% tab tabRef="k8s-113" %}}

# Install Ondat on Kubernetes 1.13

{{% operator-header %}}
{{% operator-install cmd="kubectl" %}}
{{% operator-secret storageos_version="2" %}}
{{% operator-cr-v2 cmd="kubectl" sched_version="1.13" platforms="upstream,eks,aks,gke" %}}
{{% license-cluster %}}

{{% /tab %}}
{{< /tabs >}}

{{% include "content/first-volume.md" %}}
