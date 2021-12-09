---
title: "Support"
linkTitle: "Support"
weight: 800
description: >
  How to ask for Ondat support.
---

There are several ways to reach us if you require support. The fastest way to
get in touch is to [join our public Slack
channel.](https://slack.storageos.com) <script async defer
src="http://slack.storageos.com/slackin.js"></script>

You can file a support ticket via email to [
support@storageos.com](mailto:support@storageos.com), or use our [Help Desk
portal](https://support.storageos.com)

To help us provide effective support, we request that you provide as much
information as possible when contacting us. The list below is a suggested
starting point. Additionally, please include anything specific, such as log
entries, that may help us debug your issue. 

Information about the cluster can be automatically sent to Ondat engineers
as mentioned in the section [Ondat Diagnostic
Bundle](/docs/support/contactus#storageos-cluster-diagnostic-bundle).

## Platform
- Cloud provider/Bare metal
- OS distribution and version
- Kernel version
- docker version and installation procedure (distro packages or docker install)

## Ondat 
- Version of Ondat
- `storageos get nodes`
- `storageos get volumes`
- `storageos describe volume VOL_ID` # in case of issues with a specific volume

## Orchestrator related (Kubernetes, OpenShift, etc)
- Version and installation method
- Managed or self managed?
- `kubectl -n kube-system get pod` 
- `kubectl -n kube-system logs -lapp=storageos -c storageos`
- `kubectl -n kube-system get storageclass`
- Specific for your namespaces: `kubectl describe pvc PVC_NAME` 
- Specific for your namespaces: `kubectl describe pod POD_NAME` 

## Ondat Cluster Diagnostic Bundle

Ondat has a cluster diagnostic function that aggregates cluster
information.

The cluster diagnostic bundle is created only when a user chooses to do so. For
convenience the cluster diagnostic bundle can either be uploaded to Ondat
or downloaded to the machine running the browser or CLI. The cluster diagnostic
bundle is uploaded from a Ondat node to a Ondat GCP encrypted bucket
using a TLS encrypted connection. The upload takes place only after user
confirmation.

As a general outline the following information is sent to us:

- Ondat logs
- Ondat cluster state - node config, volumes and namespaces
- output of `storageos describe node`
- output of `lshw`
- output of `dmesg`

See [Support Bundle]({{< ref "docs/reference/bundle.md" >}}) for an exhaustive list of what is included in the cluster diagnostic bundle.

Ondat engineers might ask for a cluster diagnostic bundle to be generated during
support cases.

The information given in the cluster cluster diagnostic bundle is only used for support purposes
and it will be removed once the data is no longer needed for such purposes.
In case the information is sensitive and can't be given to Ondat, please
make sure that support engineers have as much information about your
environment as possible.

You can generate a cluster diagnostic bundle through the Ondat [GUI](/docs/reference/gui) by
navigating to the `Cluster` menu and downloading the Ondat support Bundle.
The cluster cluster diagnostic bundle can also be generated using the CLI command below.

```bash
$ storageos get diagnostics -o storageos-diagnostic-bundle
```
