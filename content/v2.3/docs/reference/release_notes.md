---
title: Release notes
---

We recommend always using "tagged" versions of Ondat rather than "latest",
and to perform upgrades only after reading the release notes.

The latest tagged release is `{{< param latest_node_version >}}`. For
installation instructions please see our
[Install]({{< ref "docs/reference/cluster-operator/install.md">}}) page.

The latest CLI release is `{{< param latest_cli_version >}}`, available from
[Github](https://github.com/storageos/go-cli/releases).

# Upgrading

To upgrade from version 1.x to 2.x, please contact [support]({{< ref
"docs/support.md" >}}) for assistance.

## v2.3.4 - Released 2021-03-24

- controlplane/build: Use Sentry prod-url for release branches (CP-4600).
- controlplane/csi: Improve CSI handler timeout (CP-4585).
- controlplane/dataplane: UUID mapping cleanup on failed volume creation (CP-4588).
- controlplane/slog: Improve RPC error logging (CP-4616).
- dataplane: Allocate fewer aio contexts per volume (DP-305)
- dataplane: Defer fallocate(2) until first write (DP-312).
- dataplane: Don't fail replica sync if inter-node connection establishment is slow (DP-319, DP-280).
- dataplane: Improve logging around gRPC context cancellations (DP-315).
- dataplane: Improve rollback for failed volume creation (DP-308).
- dataplane: New support tool to cleanup orphaned volume storage (DP-307).
- dataplane: supctl can reap named volumes (DP-309).
- k8s: API token reset failures should trigger re-authentication directly (#38).
- k8s: Increase lint timeout to reduce CI errors (#305).
- k8s: Remove PriorityClass from helper pods (#312).
- k8s: Toleration defaults for helper pods (#311).
- k8s: Use ubi-minimal base image directly (#307).

## v2.3.3 - Released 2021-02-12

- Support CSI ListVolumes() API, addressing volume attach problems seen by some
  customers.
- Quality-of-life fixes.

### New

- operator: Use CSI attacher v3 for k8s 1.17+.
- controlplane/csi: ListVolumes support.

### Fixed

- api-manager: Reset api after token refresh error.
- operator: Set scheduler when PVCs use default StorageClass.
- operator: Update base container image.
- controlplane/volumerpc: "Got unknown replica state 0" discards results.
- controlplane/healthcheck: Combined sources fires callback in initialisation.
- controlplane/fsm: Perform state match check before version check.

## v2.3.2 - Released 2020-11-25

### Fixed

- controlplane/rejoin: Failure to delete data causes re-advertise loop.
- controlplane/rejoin: Handle timeout waiting for progress report.
- dataplane/log: Change buffering of `symmetra` output to prevent stalls.

## v2.3.1 - Released 2020-11-16

- Allows access to `ReadWriteMany` shared volumes when running containers as a
non-root user.

### Fixed

- nfs: root squash to uid=0 is now configured on all shared volumes.

## v2.3.0 - Released 2020-10-31

This release adds production-grade shared file support to v2, previously a
technology preview in v1.

### Breaking

- The `v2.3.0` operator is no longer able to run Ondat v1.

### New

- Adds support for `ReadWriteMany` shared volumes.  See
  [ReadWriteMany]({{< ref "docs/concepts/rwx.md" >}}).
- Adds `api-manager` deployment to support shared volumes.  See [the api
  manager](https://github.com/storageos/api-manager) Github repository for more
  information.
- Kubernetes 1.19 support.

### Improved

- dataplane: Reduce replication thread usage by having the replication processes
  share the main thread pool.  This helps ensure that there isn't a spike in
  thread usage when a node recovers and begins re-syncing its volumes.  This is
  particularly relevant on CRIO-based orchestrators such as Openshift where the
  default maximum allowed PID limit (which also governs the thread limit) is
  low.
- dataplane: Detect and log the effective maximum PID limit on startup.
- dataplane: Internal device presentation mappings are now ephemeral and are not
  persisted across reboots.
- dataplane: Disabled default verbose logging for fdatasync/flushWAL timers.
- dataplane: Log both volume inode and UUID in replication error messages for
  easier correlation.
- dataplane: On startup, ensure any remnant devices that may have been left
  after an unclean shutdown have been properly cleared.
- dataplane: Signal when all startup tasks complete.  This ensures no IO can be
  initiated before this time.
- ha: Implement a backoff when attempting to repoint an attached volume after
  the master has failed.
- ha: Replicas can now rejoin after an asymmetric partition. This can occur when
  the master has not lost communication to the replica, but the replica can't
  communicate with the master.  Previously the replica would not be able to
  rejoin until the master determined it had failed.
- ha: A master that was partitioned can now re-join to the new master as a
  replica.
- api: node label changes update target node prior to committing new state.
- api: Validation errors now include more information on the failure and how to
  resolve.
- csi: Volume resize error messages (e.g. capacity exceeded) now passed through
  in CSI response.
- csi: Volume attachment is now verified prior to mount for more instructive
  error message.
- csi: Returns `RESOURCE EXHAUSTED` error when attempting to exceed maximum of
  250 Ondat volume attachments per node.
- diagnostics: Multiple improvements to bundle collection and collected data.
- ui: Allow collection of partial diagnostics bundles.
- ui: Tolerate clock skew when authenticating via the UI.
- licensing: Read-through cache added.  Licence updates will take up to 60s to
  propagate to all nodes.
- cli: Set replicas output formatting.
- init: Checks the effective maximum PID limit and warns if less than the
  Ondat recommended PID limit (32,768).  CRIO-based distributions such as
  Openshift have a much lower default value (1024).  Consult
  [prerequisites]({{< ref "docs/prerequisites/pidlimits.md" >}}) for more
  information.

### Fixed

- dataplane: Fixes `transport endpoint is not connected` on startup after an
  unclean shutdown.
- csi: Volume unmount requests now succeed when the mountpoint has
  already been removed by the orchestrator.
- csi: Volume detach requests now succeed when the volume has already been
  deleted.  Previously the volume would be stuck in `Terminating` status.

## v2.2.0 - Released 2020-08-18

This release focuses on performance. We analysed existing performance
characteristics across a variety of real-world use cases and ended up with
improvements across the board. Of particular note:

- Sequential reads have improved by up to 130%
- Sequential writes have improved by up to 737%
- Random reads have improved by up to 45%
- Random writes have improved by up to 135%
- I/O for large block sizes (128K) has improved by up to 353%

We are extremely proud of our performance and we love to talk about it. Have a
look at the [Benchmarking]({{< ref "docs/self-eval.md"
>}}#Benchmarking) section of the self-evaluation guide and consider sharing
your results. Our PRE engineers are available to discuss in our [slack
channel](https://storageos.slack.com).

### New

- Data engine revamp focused on provable consistency and performance. Key
  characteristics:

  - Metadata is stored in an optimised index, lowering I/O latency and improving
    performance for all workloads.
  - Large block reads/writes are now be handled in a single operation.
    Applications like Kafka will go much faster.

- On-disk compression is now disabled by default as in most scenarios this
  offers better performance. To enable on-disk compression for a specific
  workload, see [compression]({{< ref "docs/concepts/compression.md">}}).

### Improved

- dataplane: The number of I/O threads are now determined by the number of
  processing cores available.  This improves scalability and performance on
  larger servers.
- ha: Improve partition tolerance behaviour when a volume master that has lost
  its connection to etcd rejoins.
- ha: Allow replicas in unhealthy states to be remediated and re-used while
  maintaining partition tolerance.
- ha: When a master fails and the new master is not yet available, introduce a
  back-off to the redirection logic to avoid spamming the logs with connection
  failure errors.
- ha: Ignore health advertisements for local node. Local nodes are handled
  directly.
- node delete: Only refuse to delete a node if the node health can be
  authoritatively verified to be in use.
- api: Increase HTTP server write timeout.
- cli/ui: Allow partial diagnostic bundle downloads.
- ui: Namespace dropdown can now be scrolled.
- ui: Add "Job title" to UI licence form.
- logging: Log version at startup at INFO level.
- logging: Lower verbosity of SCSI warnings that do not apply to Ondat.
- diagnostics: Include logs that have been rotated.
- diagnostics: Bundle collection across providers is now done in parallel.
- build: Update base image to RHEL 8.2.
- operator: Removed DB migration utility required for v1.3 -> v1.4 upgrades.
- operator: Automatically refreshes Ondat API token without failing
  requests when the token expires.
- operator: Updated CSI attacher and provisioner to latest upstream.
- operator: Remove `cluster.local` suffix on Pod scheduler service address.
  This allows the scheduler to work in clusters with custom DNS configuration.
- operator: Defaults are now set for most CSI configuration options in the
  StorageOSCluster custom resource.

### Fixed

- csi: When unmount request is received for a volume that has already been
  unmounted, return success.
- csi: Verify volume is attached on the node before mounting it.
- xfs: Support older RHEL kernels which have an XFS library that does not
  allow reflinks/dedupe.
- dataplane: Reserve 1GiB of capacity on the target disk to allow manual cleanup
  operations, rather than filling target disk to capacity.
- operator: In some cases `/var/lib/storageos` could fail to unmount cleanly
  after a restart. This resulted in multiple entries in `/proc/mounts`.

## v2.1.0 - Released 2020-06-26

### New

- csi: Volume expansion now supported in offline mode. To expand a volume, stop
  any workloads accessing the volume, then edit the PVC to increase the
  capacity. For more information, see our [Volume Resize]({{< ref
  "docs/operations/resize.md" >}}) operations page and the [`CSI Volume
  Expansion`](https://kubernetes-csi.github.io/docs/volume-expansion.html)
  page.
- api: Volume configuration including replica count can now be updated while
  the volume is in use. Other updateable fields include labels and
  description.
- failover: Before determining that a node is offline and performing recovery
  operations, the I/O path is also verified. This provides more robust failure
  detection and ensures that nodes that are still responding to I/O do not get
  replaced. This I/O path verification is in addition to the gossip-based
  failure detection.
- operator: Default tolerations are now set for the Ondat node container.
  This helps ensure that the Ondat node container does not get evicted when
  the node is running low on resources.

### Improved

- api: Added checks to prevent deletion of a node with active volumes, or if it
  is the master of at least one volume. This helps prevent orphaned volumes.
- cli: Add an `--offline-delete` flag to allow removal of volumes whose master
  and replica nodes are offline. This allows cleanup of orphaned volumes.
- ui: Add an offline volume delete option.
- ui: Volumes can now be detached from the UI.
- cli: Labels are no longer truncated.
- api: When a new node is added to the cluster, its capacity is available to use
  immediately.

### Fixed

- ui: Favicon was missing.
- ui: Duplicate volumes could be shown on the node details page.
- operator: During uninstall a ClusterRoleBinding was not removed.

## v2.0.0 - Released 2020-05-05

### New

- operator: Ondat containers now run in the `kube-system` namespace by
  default to allow the `system-node-critical` priority class to be set. This
  instructs Kubernetes to start Ondat before application Pods, and to evict
  Ondat only after application Pods have finished. This setting was
  previously recommended in documentation; it is now the default.
- operator: Ondat CSI helper containers now run as privileged. This ensures
  that the CSI endpoint can be seen on systems with SELinux enabled.
- ui: replication progress for new or re-joining replicas is now displayed.
- ui: show warning for unlicensed clusters.
- cli: new commands:
  - licence management
  - get policy
  - create namespace
  - create policy
  - describe user
  - describe namespace
  - describe policy
  - delete user
  - delete namespace
  - delete policy
- licence: removed the default licence expiry date added for `v2.0.0-rc.1`.

### Improved

- dataplane: improved retry behaviour for network I/O.
- cli: "get volumes" for all namespaces should be done in parallel.
- cli: help text document config file
- ui: link node name and get to node details on the volume details page.
- ui: node details add available capacity spinner.
- ui: node list remove capacity values / address port.
- ui: node list show master/replica counts.
- ui: node list remove edit action.
- ui: format entity labels.
- ui: node details link volumes.
- ui: align buttons for licences.
- ui: k8s warning in "create volume" modal.
- ui: node list remove "API" from "API Address"
- ui: add some details about the Licence on the licence page.
- api: include valid for duration in login response.
- licence: restrict nodes which are unregistered after 24 hours.
- scheduler: return error for namespace/volume not found
- dataplane: start gRPC threads separately from rest of the supervisor.

### Fixed

- ui: centre licence types.
- ui: capacity in ui is per namespace.
- cli: fail gracefully if missing some output details (i.e. no node exists for id).

## v2.0.0-rc.1 - Released 2020-03-31

Initial release of version 2.x. See [Ondat v2.0 Release
Blog](https://storageos.com/storageos-2-0-release-blog) for details.

