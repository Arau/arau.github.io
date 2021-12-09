---
title: OpenShift
weight: 20
---

> Make sure the
> [prerequisites for Ondat]({{< ref "docs/prerequisites/_index.md" >}}) are
> satisfied before proceeding. Including the deployment of an etcd cluster.

> If you have installed OpenShift in AWS ensure that the requisite ports are
> opened for the worker nodes' security group.

> Make sure to add a Ondat licence after installing.

Ondat v2 supports OpenShift v4. For more information check the [OpenShift
platform]({{< ref "docs/platforms/openshift.md" >}}) page.

# Manual install

{{% operator-header %}}
{{% operator-install cmd="oc" %}}
{{% operator-secret storageos_version="2" %}}
{{% operator-cr-v2 cmd="oc" sched_version="4" platforms="openshift" %}}
{{% license-cluster %}}

{{% include "content/first-volume.md" %}}
