## Etcd low latency IO

It is recommended to run etcd on low-latency disks and keep other IO-intensive
applications separate from the etcd nodes. Etcd is very sensitive to IO latency.
Thus, the effect of disk contention can cause etcd downtime.

Batch jobs such as backups, builds or application bundling can easily cause a
high usage of disks making etcd unstable. It is recommended to run such
workloads apart from the etcd servers.
