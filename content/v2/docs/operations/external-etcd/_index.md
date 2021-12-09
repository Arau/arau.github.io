---
title: Etcd
---

Ondat uses [etcd](https://etcd.io) to store cluster metadata. Because of
the strong consistency model that etcd enforces, Ondat metadata operations
are guaranteed to be atomic and consistent.

## Installation options

Before installing Ondat, an etcd cluster needs to be prepared. There are
different topologies that fulfil this prerequisite.

1. External etcd (*Production*)
1. etcd as Pods (*Testing*)

{{< tabs tabTotal="2" tabID="9"  tabName1="Production" tabName2="Testing" >}}
{{% tab firstTab="true" tabName="production" %}}

## External Etcd

The production topology is designed to provide the highest stability for the
etcd cluster. It is necessary for normal Ondat function to have a reliable
metadata cluster. Otherwise, central operations such as provisioning,
attachment or failover of volumes cannot be performed. In the event that etcd
becomes unavailable, Ondat clusters become read only, allowing access to
data but preventing metadata changes.

It is recommended to install etcd out of the scope of the orchestrator wherever
possible. Following CoreOS best practices, a minimum of 3 independent nodes
should be dedicated to etcd. Ondat doesn't require a high performance etcd
cluster as the throughput of metadata to the cluster is low. Depending on the
level of redundancy you feel comfortable with you can install etcd on the
Kubernetes Master nodes. __Take extreme care to avoid collisions of the
Ondat etcd installation with the Kubernetes etcd when using the Kubernetes
Master nodes. Precautions such as changing the default configuration for the
client and peer ports, and ensuring the etcd data directory is modified. The
ansible playbook below will default the etcd installation directory to
`/var/lib/storageos-etcd`.__

### Installation

If you are familiar with etcd, you can proceed with the CoreOS instructions to
install etcd, otherwise this section lays out out an example installation using
Ansible.

1. Clone Ondat Helper repository
    ```bash
    git clone https://github.com/storageos/deploy.git
    cd k8s/deploy-storageos/etcd-helpers/etcd-ansible-systemd
    ```
1. Edit the inventory file
    > Target the nodes that install etcd, where the file `hosts.example` serves
    > as an example. The `ip` parameter is needed for each node.

    ```bash
    $ cat hosts.example
    [nodes]
    centos-1 ip=172.28.128.14
    centos-2 ip=172.28.128.15
    centos-3 ip=172.28.128.16

    # Edit the inventory file
    $ vi hosts.example # Or your own inventory file
    ```

1. Edit the etcd configuration
    > __If targeting Kubernetes Master nodes, you must change
    > `etcd_port_client`, `etcd_port_peers`__

    ```bash
    $ cat group_vars/all
    etcd_version: "3.3.18"
    etcd_port_client: "2379"
    etcd_port_peers: "2380"
    etcd_quota_bytes: 8589934592  # 8 GB
    etcd_auto_compaction_mode: "revision"
    etcd_auto_compaction_retention: "100"
    members: "{{ groups['nodes']  }}"
    installation_dir: "/var/lib/storageos-etcd"

    $ vi group_vars/all
    ```

1. Install
    ```bash
    ansible-playbook -i hosts.example site.yml
    ```

1. Verify installation
    > The playbook installs the `etcdctl` binary on the nodes, at
    > `/usr/local/bin`.

    ```bash
    $ ssh $NODE # Any node running the new etcd
    $ ETCDCTL_API=3 etcdctl --endpoints=127.0.0.1:2379 member list
    66946cff1224bb5, started, etcd-b94bqkb9rf,  http://172.28.0.1:2380, http://172.28.0.1:2379
    17e7256953f9319b, started, etcd-gjr25s4sdr, http://172.28.0.2:2380, http://172.28.0.2:2379
    8b698843a4658823, started, etcd-rqdf9thx5p, http://172.28.0.3:2380, http://172.28.0.3:2379
    ```

## Managed Services

When running Ondat on Managed Kubernetes services it may not be possible to
deploy with the Production etcd topology described above. It is therefore
recommended to deploy etcd on its own as much as possible, even if that means
deploying 3 independent VMs for etcd to run on.

As managed services treat nodes as ephemeral resources, if the orchestration
deletes the 3 nodes hosting etcd, the result will be catastrophic and a restore
from a backup will be needed.

If it is not possible to deploy independent VMs for etcd, etcd can be deployed
as pods, inside the cluster. This configuration requires an awareness of the
stability that etcd requires. __You can use the [etcd-as-pods](
{{< ref "docs/operations/external-etcd/_index.md#installation-options" >}})
installation option, but be aware of the precautions that need to be taken.__

## Why External Etcd

etcd is a distributed key-value store database focused on strong consistency.
That means that etcd nodes perform operations across the cluster to ensure
quorum. In the case that quorum is lost, an etcd node stops and marks its
contents as read-only. It cannot guarantee that the data being held is valid.
Another peer might have a newer version that has not been delivered. Quorum is
fundamental for etcd operations.

In a Kubernetes environment, applications are scheduled across and in some
scenarios such as "DiskPressure" they may need to be evicted from a node, and
be scheduled onto a different node. With an application such as etcd, the
scenario described can result in quorum being lost, making the cluster unable
to recover automatically. Usually a 3 node etcd cluster can survive losing one
node and recover. However, losing a second node at the same time or even having
a network partition between them will result in quorum lost.

## Bind Etcd IPs to Kubernetes Service

Kubernetes external services use a DNS name to reference external endpoints.
You can use the example from the [helper github
repository](https://github.com/storageos/deploy/tree/master/k8s/deploy-storageos/etcd-helpers/etcd-external-svc)
to deploy the external Service. That might be of use when monitoring etcd from
Prometheus.

{{% /tab %}}
{{% tab  tabName="testing" %}}

## Etcd as Pods

etcd can be deployed in Kubernetes using the official [etcd-operator](
https://github.com/coreos/etcd-operator).

Deploying etcd in Kubernetes makes the etcd installation very easy, however be
aware that even though the official etcd-operator is maintained by RedHat, it
hasn't been under active development since 2019. As such it may be considered
an archived project. For an actively maintained etcd Operator you might want to
check the [Improbable etcd
Operator](https://github.com/improbable-eng/etcd-cluster-operator).

Examples of deploying etcd clusters using the etcd-operator on [Kubernetes](
https://github.com/storageos/deploy/tree/master/k8s/deploy-storageos/etcd-helpers/etcd-operator-example)
and
[OpenShift](https://github.com/storageos/deploy/tree/master/openshift/deploy-storageos/etcd-helpers/etcd-operator-example)
are available.

Since Kubernetes 1.16 the deployment api uses "apps/v1". Once you have cloned
the coreos etcd operator repository, you will need to change the apiVersion of
the file "examples/deployment.yaml" from `extensions/v1beta1` to `apps/v1`.

The official etcd-operator repository also has a backup deployment operator
that can help backup etcd data. Make sure you take frequent backups of the etcd
cluster as it holds all the Ondat cluster metadata.

## Known etcd-operator issues

This topology is only recommended for deployments where isolated nodes cannot be
used.

etcd is a distributed key-value store database focused on strong consistency.
That means that etcd nodes perform operations across the cluster to ensure
quorum. If quorum is lost, etcd nodes stop and etcd marks its contents as
read-only. This is because it cannot guarantee that new data will be valid.
Quorum is fundamental for etcd operations. When running etcd in pods it is
therefore important to consider that a loss of quorum could arise from etcd
pods being evicted from nodes.

Operations such as Kubernetes Upgrades with rolling node pools could cause a
total failure of the etcd cluster as nodes are discarded in favor of new ones.

A 3 etcd node cluster can survive losing one node and recover, a 5 node cluster
can survive the loss of two nodes. Loss of further nodes will result in quorum
being lost.

The etcd-operator doesn't support a full stop of the cluster. Stopping the etcd
cluster is not possible unless a backup is restored.

{{% /tab %}}

{{< /tabs >}}

## Ondat and Etcd

When installing Ondat, the etcd endpoints are passed in a StorageOSCluster Custom
Resource.

For instance:
```
apiVersion: "storageos.com/v1"
kind: StorageOSCluster
metadata:
  name: "storageos"
spec:
  secretRefName: "storageos-api" # Reference from the Secret created in the previous step
  secretRefNamespace: "default"  # Namespace of the Secret

  (...)

  kvBackend:
    address: 'storageos-etcd-client.etcd:2379' # Example address, change for your etcd endpoint
   #address: '10.42.15.23:2379,10.42.12.22:2379,10.42.13.16:2379' # You can set etcd server ips
    backend: 'etcd'
```

> Note the `kvBackend.address` section.

For full Custom Resource documentation check [StorageOSCluster resource definition](
/docs/reference/cluster-operator/configuration).

## Best practices

Ondat uses etcd as a service, whether it is deployed following the above
instructions or as a custom installation. It is expected that the user
maintains the availability and integrity of the etcd cluster.

It is highly recommended to keep the cluster backed up and ensure high
availability of its data. It is also important to keep the latency between
Ondat nodes and the etcd replicas low. Deploying an etcd cluster in a
different data center or region can make Ondat detect etcd nodes as
unavailable due to latency. A 10ms latency between Ondat and etcd would be
the maximum threshold for proper functioning of the system.

### Monitoring

It is highly recommended to add monitoring to the etcd cluster. etcd serves
Prometheus metrics on the client port `http://etc-url:2379/metrics`.

You can use Ondat developed Grafana Dashboards for etcd. When using etcd
for production, you can use the
[etcd-cluster-as-service](https://grafana.com/grafana/dashboards/10322), while
the [etcd-cluster-as-pod](https://grafana.com/grafana/dashboards/10323) can be
used when using etcd from the operator.

### Defragmentation

etcd uses revisions to store multiple versions of keys. Compaction removes all
key revision prior to a certain revision from etcd. Typically the etcd
configuration enables the automatic compaction of keys to prevent performance
degradation and limit the storage required. Compaction of revisions can create
fragmentation that means space on disk is available for use by etcd but is
unavailable for use by the file system. In order to reclaim this space, etcd
can be defragmented.

Reclaiming space is important because when the etcd database file grows over
the "DB_BACKEND_BYTES" parameter, the cluster triggers an alarm and sets itself
read only and only allows reads and deletes. To avoid hitting the db backend
bytes limit, compaction and defragmentation are required. How often
defragmentation is required depends on the churn of key revisions in etcd.

The Grafana Dashboards mentioned above indicate when nodes require
defragmentation. Be aware that defragmentation is a blocking operation that is
performed per node, hence the etcd node will be locked for the duration of the
defragmentation. Defragmentation usually takes a few milliseconds to complete.

