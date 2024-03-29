{{ $cmd := .Get "cmd"}}
{{ $platform := .Get "platform" }}
{{ $sched_version := .Get "sched_version" }}

The recommended way to run Ondat on an OpenShift {{ $sched_version }}
cluster is to deploy the Ondat Cluster Operator and bootstrap Ondat
using a Custom Resource.

## Prerequisites

1. Ensure any firewalls permit the [appropriate ports]({{ ref . "docs/prerequisites/firewalls.md" }}).

1. If your cluster enables SELinux, add the following permissions for each of
   the nodes that run Ondat.
        ```bash
        setsebool -P virt_sandbox_use_fusefs on
        setsebool -P virt_use_fusefs on
        ```

    >The `-P` option makes the change persistent after reboots.

1. Ensure that your docker installation has mount propagation enabled per our
   [mount propagation prerequisites]({{ ref . "docs/prerequisites/mountpropagation.md"}}).

1. Enable the `MountPropagation` flag by appending feature gates to the API and
   controller (you can apply these changes using the Ansible Playbooks)

    > Note: If you are using atomic installation rather than origin, the location of
    > the yaml config files and service names might change.

    - Add to the KubernetesMasterConfig section (/etc/origin/master/master-config.yaml):

        ```bash
        kubernetesMasterConfig:
          apiServerArguments:
              feature-gates:
              - MountPropagation=true
          controllerArguments:
              feature-gates:
              - MountPropagation=true
        ```

    - Add to the feature-gates to the kubelet arguments (/etc/origin/node/node-config.yaml):

        ```bash
        kubeletArguments:
            feature-gates:
            - MountPropagation=true
        ```

    >  **Warning:** Restarting OpenShift services can cause downtime in the cluster.

{{- if or (eq $sched_version "3.10") (eq $sched_version "3.11") }}
    - Restart services in the MasterNode/s
        ```bash
        master-restart api
        master-restart controllers

        # Restart kubelet
        systemctl restart atomic-openshift-node.service
       ```

    - Restart service in all Nodes 
       ```bash
        # Restart kubelet
        systemctl restart atomic-openshift-node.service
        ```
{{- else }}
    - Restart services in the MasterNode `origin-master-api.service`,
      `origin-master-controllers.service` and `origin-node.service`
    - Restart service in all Nodes `origin-node.service`

    > Usually through `systemctl restart (origin-node.service|atomic-openshift-node.service)`
{{- end }}

&nbsp;
