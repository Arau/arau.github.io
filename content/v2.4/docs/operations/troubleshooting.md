---
title: Troubleshooting
linkTitle: Troubleshooting
aliases:
  - /docs/platforms/kubernetes/troubleshoot
  - /docs/platforms/kubernetes/troubleshoot/install
  - /docs/platforms/kubernetes/troubleshoot/volumes
  - /docs/platforms/openshift/troubleshoot
  - /docs/platforms/openshift/troubleshoot/install
  - /docs/platforms/openshift/troubleshoot/volumes
  - /docs/platforms/rancher/troubleshoot
  - /docs/platforms/rancher/troubleshoot/install
  - /docs/platforms/rancher/troubleshoot/volumes
  - /docs/platforms/dockerce/troubleshoot
  - /docs/platforms/dockerce/troubleshoot/install
  - /docs/platforms/dockerce/troubleshoot/volumes
---

This section is aimed to help you troubleshoot issues in your cluster, whether
they are related to the Ondat installation, integration with
orchestrators or common misconfigurations.

## Tools

To be able to troubleshoot issues the [Ondat
CLI](https://github.com/storageos/go-cli) is required.

{{% include "content/troubleshoot/mount-in-pod-stat.md" %}}
{{% include "content/troubleshoot/pvc-pending-fail-to-dial.md" %}}
{{% include "content/troubleshoot/pvc-pending-missing-secret.md" %}}

{{% include "content/troubleshoot/nodename-vs-nodehostname.md" %}}
{{% include "content/troubleshoot/ports-closed.md" %}}

{{% include "content/troubleshoot/join-to-master-node.md" %}}
{{% include "content/troubleshoot/lio-init.md" %}}
{{% include "content/troubleshoot/lio-dataplane.md" %}}
{{% include "content/troubleshoot/scc-missing.md" %}}

## Getting Help

If our troubleshooting guides do not help resolve your issue, see our
[support section]({{< ref "docs/support.md" >}}) for details on how
to get in touch with us.
