---
linkTitle: Labels
title: Ondat Feature labels
---


Feature labels are a powerful and flexible way to control storage features,
especially when combined with [rules]({{< ref "docs/reference/cli/rule.md" >}}).

Labels can be applied to various Ondat artefacts. Applying specific feature
labels triggers compression, replication and other storage features. No feature
labels are present by default.

## Ondat Node labels

Nodes do not have any feature labels present by default.  When Ondat is run
within Kubernetes with the [Cluster Operator]({{< ref
"docs/reference/cluster-operator/_index.md" >}}), any node labels set on
Kubernetes nodes are available within Ondat.  Node labels may also be set
with the CLI or UI.

| Feature             | Label                               | Values                               | Description                                                                                                                                                                                                  |
| :------------------ | :---------------------------------- | :----------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------                                                               |
| Deployment type     | `storageos.com/deployment`          | strings [`computeonly`,`mixed`]      | Specifies whether a node should be `computeonly` where it only acts as a client and does not host volume data locally, or `mixed` (the default), where the node can operate in both client and server modes. |
| Region              | `iaas/region`                       | string                               | Set automatically in AWS, Azure and GCE.  e.g. `eu-west-1`.  Not currently used by Ondat but available for use in rules.                                                                         |
| Failure domain      | `iaas/failure-domain`               | string                               | Used to spread master and replicas across different failure domains.  Set automatically in AWS, Azure and GCE, e.g. `eu-west-1b`                                                                             |
| Update domain       | `iaas/update-domain`                | string                               | Set by some cloud providers to perform sequential updates/reboots.  Not currently used by Ondat but available for use in rules.                                                                          |
| Size                | `iaas/size`                         | string                               | The node hardware configuration, as set by the cloud provider, e.g. `m5d.xlarge`.  Not currently used by Ondat but available for use in rules.                                                           |

To add a label to a node:

```bash
storageos node update --label-add storageos.com/deployment=computeonly nodename
```

## Ondat Pod Labels

| Feature             | Label                               | Values           | Description                                                                                                                                                                  |
| :------------------ | :---------------------------------- | :--------------- | :---------------------------------------------------------------------------------------------------------------------------------------------                               |
| Fencing             | `storageos.com/fenced`              | true / false     | Enables Ondat fencing of pods on unavailable nodes. For more information about fencing prerequisites please see the [Fencing](/docs/operations/fencing) operations page. |

To add the fencing label to a pod use kubectl:
```bash
kubectl label pod <POD_NAME> key=value
kubectl label pod mydb-pod storageos.com/fenced=true
```

## Ondat Pool labels

Pools do not have any labels present by default.

| Feature             | Label                               | Values                               | Description                                                                                                                                                                                                                        |
| :------------------ | :---------------------------------- | :----------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------                                                                                     |
| Overcommitment      | `storageos.com/overcommit`          | integers [+]                         | Sets the percentage of overcommitment allowed for the pool (see [here]({{< ref "docs/operations/overcommitment.md" >}})).                                                                                                                                                                        |

To add overcommit labels to a pool:

```bash
storageos pool update --label-add storageos.com/overcommit=20 default
```

## Ondat Volume labels

Volumes do not have any feature labels present by default

| Feature             | Label                               | Values                               | Description                                                                                                                                                                                                                        |
| :------------------ | :---------------------------------- | :----------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------                                                                                     |
| Caching             | `storageos.com/nocache`             | true / false                         | Switches off caching.                                                                                                                                                                                                              |
| Compression         | `storageos.com/nocompress`          | true / false                         | Switches off compression of data at rest and in transit.                                                                                                                                                                           |
| Encryption          | `storageos.com/encryption`          | true / false                         | Enables volume encryption, more details [here](/docs/operations/encrypted-volumes)                                                                                                                                                 |
| Failure mode        | `storageos.com/failure.mode`        | strings [`soft`,`hard`,`alwayson`]   | Soft failure mode works together with the failure tolerance. Hard is a mode where any loss in desired replicas count will mark volume as unavailable. AlwaysOn is a mode where as long as master is alive volume will be writable. |
| Failure tolerance   | `storageos.com/failure.tolerance`   | integers [0, 4]                      | Specifies how many failed replicas to tolerate, defaults to (Replicas - 1) if Replicas > 0, so if there are 2 replicas it will default to 1.                                                                                       |
| Placement           | `storageos.com/hint.master`         | Node hostname or uuid                | Requests master volume placement on the specified node.  Will use another node if request can't be satisfied.                                                                                                                      |
| QoS                 | `storageos.com/throttle`            | true / false                         | Deprioritizes traffic by reducing the rate of disk I/O, when true.                                                                                                                                                                 |
| Replication         | `storageos.com/replicas`            | integers [0, 5]                      | Replicates entire volume across nodes. Typically 1 replica is sufficient (2 copies of the data); more than 2 replicas is not recommended.                                                                                          |

To create a volume with a feature label:

```bash
storageos volume create --label storageos.com/throttle=true --label storageos.com/replicas=1 volumename
```

When using the Kubernetes CSI driver (available from Kubernetes 1.10), volume
labels can also be added to the parameters section of the StorageClass. This
means that all volumes created with the specific StorageClass will have
Ondat volume labels applied to them.

For example the StorageClass below will create `ext4` formatted volumes with a
single Ondat replica, in the `default` [pool]({{< ref "docs/concepts/pools.md" >}}).

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ondat-replicated
  parameters:
    fsType: ext4
    pool: default
    storageos.com/replicas: "1"
provisioner: storageos
```
