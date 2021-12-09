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
as mentioned in the section [Ondat Cluster
Report](/docs/support/contactus#storageos-cluster-report).

## Platform
- Cloud provider/Bare metal
- OS distribution and version
- Kernel version
- docker version and installation procedure (distro packages or docker install)

## Ondat 
- Version of Ondat
- `storageos node ls`
- `storageos volume ls`
- `storageos volume inspect VOL_ID` # in case of issues with a specific volume

## Orchestrator related (Kubernetes, OpenShift, etc)
- Version and installation method
- Managed or self managed?
- `kubectl -n kube-system get pod` 
- `kubectl -n kube-system logs -lapp=storageos -c storageos`
- `kubectl -n kube-system get storageclass`
- Specific for your namespaces: `kubectl describe pvc PVC_NAME` 
- Specific for your namespaces: `kubectl describe pod POD_NAME` 

## Ondat Cluster Report

Ondat has a cluster diagnostic function that aggregates cluster information.

For each node the following is collected:

- Ondat logs
- output of `storageos inspect node`
- output of `lshw`
- output of `dmesg`

Ondat engineers might ask for a report to be generated during
support cases.

The information given in the cluster report is only used for support purposes
and it will be removed once the data is no longer needed for such purposes.
In case the information is sensitive and can't be given to Ondat, please
make sure that support engineers have as much information about your
environment as possible.

The cluster report is created only when a user chooses to do so. For
convenience the report can either be uploaded to Ondat or downloaded to the
machine running the browser. The report is uploaded from a Ondat node to a
Ondat GCP encrypted bucket using a TLS encrypted connection. The upload
takes place only after user confirmation.

You can generate a report through the Ondat [GUI](/docs/reference/gui) by
navigating to the `Cluster` menu. You can also directly connect to the cluster
diagnostic API endpoint and retrieve the bundle. Note that only a user with the
Admin role can create Diagnostic Bundles.
```bash 
curl -u <ADMIN_USERNAME>:<ADMIN_PASSWORD> http://<NODE_IP>:5705/v1/diagnostics/cluster -o diagnostic.tar
```
