---
title: Rancher
weight: 30
---

> Make sure the 
> [prerequisites for Ondat]({{< ref "docs/prerequisites/_index.md" >}}) are
> satisfied before proceeding.

> Make sure to add a Ondat licence after installing.

> Ondat transparently supports Rancher deployments on CentOS, RHEL,
> Debian, Ubuntu or RancherOS (CSI is not supported on RancherOS) and can
> support other Linux distributions as detailed on the [System Configuration
> page]({{< ref "docs/prerequisites/systemconfiguration.md" >}}) if the
> appropriate kernel modules are available.


&nbsp;

The Ondat v2 installation using the Rancher Catalog will be available soon.

{{< tabs tabTotal="1" tabID="1" tabHREFPrefix=""  tabName1="Manual" >}}
{{% tab firstTab="true" tabRef="manual" %}}

# Manual Installation

{{% operator-header %}}
{{% operator-install cmd="kubectl" %}}
{{% operator-secret storageos_version="2" %}}
{{% operator-cr-v2 cmd="kubectl" sched_version="1.17" platforms="rancher" %}}
{{% license-cluster %}}

{{% /tab %}}
{{< /tabs >}}

{{% include "content/first-volume.md" %}}
