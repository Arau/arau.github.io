## Resource reservations

Ondat resource consumption depends on the workloads and the Ondat
features in use.

The recommended minimum memory reservation for the Ondat Pods is 512MB for
non-production environments. However it is recommended to prepare nodes so
Ondat can operate with at least with 1-2GB of memory. Ondat frees
memory when possible.

For production environments, we recommend 4GB of Memory and 1 CPU as a minimum
and to test Ondat using realistic workloads and tune resources accordingly.

Ondat Pods resource allocation will impact directly on the availability of
volumes in case of eviction or resource limit triggered restart. It is
recommended to not limit Ondat Pods.

Ondat implements a storage engine, therefore limiting CPU consumption might
affect the I/O throughput of your volumes.
