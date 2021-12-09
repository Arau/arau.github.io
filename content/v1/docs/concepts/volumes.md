---
title: Volumes
linkTitle: Volumes
---


Ondat volumes are a logical construct which represent a writeable volume
and exhibit standard POSIX semantics. We present volumes as mounts into
containers via the Linux LIO subsystem.

Conceptually, Ondat volumes have a frontend presentation, which is the
side the application sees, and a backend presentation, which is the actual
on-disk format. Depending on the configuration, frontend and backend components
may be on the same or different hosts.

Volumes are formatted using the linux standard ext4 filesystem by default.
Kubernetes users may change the default filesystem type to ext2, ext3, ext4,
or xfs by setting the fsType parameter in their StorageClass (See
[Supported
Filesystems](/docs/reference/filesystems#persistent-volume-filesystems) for
more information). Different filesystems may be supported in the future.


Ondat volumes are represented on disk in two parts.


Actual volume data is written to blob files in
`/var/lib/storageos/data/dev[\d+]`. Inside these directories, each Ondat
 block device gets two blob files of the form `vol.xxxxxx.y.blob`, where x is
the inode number for the device, and y is an index between 0 and 1. We provide
two blob files in order to ensure that certain operations which require locking
do not impede in-flight writes to the volume.

In systems which have multiple `/var/lib/storageos/data/dev[\d+]` directories,
we place two blob files per block device. This allows us to load-balance writes
across multiple devices. In cases where dev directories are added after a
period of run time, later directories are favoured for writes until the data is
distributed evenly across the blob files.


Metadata is kept in directories named `/var/lib/storageos/data/db[\d+]`. We
maintain an index of all blocks written to the blob file inside the metadata
store, including checksums. These checksums allow us to detect bitrot, and
return errors on reads, rather than serve bad data. In future versions we may
implement recovery from replicas for volumes with one or more replicas defined.

Ondat metadata requires approximately 2.7GB of storage per 1TB of allocated
blocks in the associated volume. This size is consistent irrespective of data
compression defined on the volume.


To ensure deterministic performance, individual Ondat volumes must fit on a single
node. In situations where [overcommit]({{< ref "docs/operations/overcommitment.md"
>}}) is applied, a scaling factor is applied when determining whether to place a
volume on a node.


We present various metrics regarding Ondat volumes, including used capacity
and throughput, via our [Prometheus Endpoint]({{< ref
"docs/reference/prometheus.md" >}}).
