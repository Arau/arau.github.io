---
title: OpenShift
weight: 20
aliases:
  - /install/openshift/
  - /docs/platforms/openshift/install/
  - /docs/platforms/openshift/install/4.3
  - /docs/platforms/openshift/install/4.2
  - /docs/platforms/openshift/install/4.1
  - /docs/platforms/openshift/install/4.2
  - /docs/platforms/openshift/install/4.3
  - /docs/platforms/openshift/install/4.4
  - /docs/platforms/openshift/install/4.5
  - /docs/platforms/openshift/install/4.6
  - /docs/platforms/openshift/install/4.7
  - /docs/platforms/openshift/install/4.8
---

> Make sure the
> [prerequisites for Ondat]({{< ref "docs/prerequisites/_index.md" >}}) are
> satisfied before proceeding. Including the deployment of an etcd cluster and
> configuration of CRI-O PID limits.

> For OpenShift upgrades, refer to the
> [OpenShift platform page]({{< ref "docs/platforms/openshift.md#openshift-upgrades" >}}).

> If you have installed OpenShift in AWS ensure that the requisite ports are
> opened for the worker nodes' security group.

> Make sure to add a Ondat licence after installing.

Ondat v2 supports OpenShift v4. For more information, see the [OpenShift
platform]({{< ref "docs/platforms/openshift.md" >}}) page.


{{< tabs tabTotal="3" tabID="1" tabHREFPrefix="" tabName1="OperatorHub" tabName2="RH Marketplace" tabName3="Manual" >}}
{{% tab firstTab="true" tabRef="OperatorHub" %}}

# OperatorHub


{{% openshift4-install-v2 cmd="oc" platform="openshift" sched_version="4.8" %}}

{{% /tab %}}
{{% tab tabRef="RH Marketplace" %}}

# Red Hat Marketplace


{{% openshift4-install-marketplace cmd="oc" platform="openshift" sched_version="4.8" %}}

{{% /tab %}}
{{% tab tabRef="Manual" %}}
# Manual install

{{% operator-header %}}
{{% operator-install cmd="oc" %}}
{{% operator-secret storageos_version="2" %}}
{{% operator-cr-v2 cmd="oc" sched_version="4" platforms="openshift" %}}
{{% license-cluster %}}

{{% /tab %}}
{{< /tabs >}}

{{% include "content/first-volume.md" %}}
