---
linkTitle: Prometheus Endpoint
title: Prometheus
---

Our [Prometheus](https://prometheus.io) endpoint exposes metrics about
Ondat artefacts (such as volumes), as well as internal Ondat
components.

Customers may scrape these metrics using Prometheus itself, or any compatible client, such as the popular [Telegraf](https://www.influxdata.com/time-series-platform/telegraf/) agent shipped with InfluxDB.

Artefact Metrics
----------------

Artefact metrics are those which instrument a specific Ondat artefact. Typically these relate to volumes. These are useful for general purpose monitoring.

Volume metrics make use of the following Ondat logical concepts:

- Frontend - the layer serving a volume to an application. Always on the same host as the application.
- Network - the layer serving IO to remote volumes
- Backend - the layer representing IO to/from physical media. Not necessarily on the same host as an application.

| Name | Explanation | Additional Notes |
|---|---|---|
| storageos_volume_backend_read_bytes_total | Backend read operations | Bandwidth/volume  |
| storageos_volume_backend_read_total | Backend read operations | Can be used to derive IOPS  |
| storageos_volume_backend_write_bytes_total  | Backend write bytes | Bandwidth/volume  |
| storageos_volume_backend_write_total  | Backend write operations  | Can be used to derive IOPS  |
| storageos_volume_capacity_bytes | Provisioned volume size bytes |   |
| storageos_volume_frontend_read_bytes_total  | Frontend read bytes | Bandwidth/volume  |
| storageos_volume_frontend_read_error_total  | Frontend read errors  |   |
| storageos_volume_frontend_read_total  | Frontend read operations  | Can be used to derive IOPS  |
| storageos_volume_frontend_write_bytes_total | Frontend write bytes  | Bandwidth/volume  |
| storageos_volume_frontend_write_error_total | Frontend write errors |   |
| storageos_volume_frontend_write_total | Frontend write operations | Can be used to derive IOPS  |
| storageos_volume_network_read_bytes_total | Network read bytes  | Bandwidth/volume  |
| storageos_volume_network_read_error_total | Network read errors |   |
| storageos_volume_network_read_retry_total | Network read retries  |   |
| storageos_volume_network_read_total | Network read operations | Can be used to derive IOPS  |
| storageos_volume_network_read_wait_retry_total  | Network read delayed retries  | QOS related |
| storageos_volume_network_write_bytes_total  | Network write bytes | Bandwidth/volume  |
| storageos_volume_network_write_error_total  | Network write errors  |   |
| storageos_volume_network_write_retry_total  | Network write retries |   |
| storageos_volume_network_write_total  | Network write operations  | Can be used to derive IOPS  |
| storageos_volume_network_write_wait_retry_total | Network write delayed retries | QOS related |
| storageos_volume_utilisation_actual_bytes | Backend non-zero device blocks | A count of 1MiB chunks that have been written to since volume creation. The count is taken before compression, encryption etc. |
| storageos_volume_utilisation_apparent_bytes | Backend storage size | Total blob file size on the host machine|


Node Metrics
------------

Our node metrics instrument various aspects of our container operation. These are illustrative of the health of your cluster, and we may ask you to
provide them during a support engagement.

| Name                                                   | Explanation                                                                                 | Additional Notes                       |
| ---                                                    | ---                                                                                         | ---                                    |
| exposer_bytes_transferred                              | bytesTransferred to metrics services                                                        |                                        |
| exposer_request_latencies                              | Latencies of serving scrape requests, in microseconds                                       |                                        |
| exposer_request_latencies_count                        | Total number of exposer_request_latencies                                                   |                                        |
| exposer_request_latencies_sum                          | Sum of all exposer_request_latencies                                                        |                                        |
| exposer_total_scrapes                                  | Number of times metrics were scraped                                                        |                                        |
| go_gc_duration_seconds                                 | A summary of the GC invocation durations.                                                   |                                        |
| go_gc_duration_seconds_count                           | Total number of go_gc_duration_seconds                                                      |                                        |
| go_gc_duration_seconds_sum                             | Sum of all go_gc_duration-seconds                                                           |                                        |
| go_goroutines                                          | Number of goroutines that currently exist.                                                  |                                        |
| go_info                                                | Information about the Go environment.                                                       |                                        |
| go_memstats_alloc_bytes                                | Number of bytes allocated and still in use.                                                 |                                        |
| go_memstats_alloc_bytes_total                          | Total number of bytes allocated, even if freed.                                             |                                        |
| go_memstats_buck_hash_sys_bytes                        | Number of bytes used by the profiling bucket hash table.                                    |                                        |
| go_memstats_frees_total                                | Total number of frees.                                                                      |                                        |
| go_memstats_gc_cpu_fraction                            | The fraction of this program's available CPU time used by the GC since the program started. |                                        |
| go_memstats_gc_sys_bytes                               | Number of bytes used for garbage collection system metadata.                                |                                        |
| go_memstats_heap_alloc_bytes                           | Number of heap bytes allocated and still in use.                                            |                                        |
| go_memstats_heap_idle_bytes                            | Number of heap bytes waiting to be used.                                                    |                                        |
| go_memstats_heap_inuse_bytes                           | Number of heap bytes that are in use.                                                       |                                        |
| go_memstats_heap_objects                               | Number of allocated objects.                                                                |                                        |
| go_memstats_heap_released_bytes                        | Number of heap bytes released to OS.                                                        |                                        |
| go_memstats_heap_sys_bytes                             | Number of heap bytes obtained from system.                                                  |                                        |
| go_memstats_last_gc_time_seconds                       | Number of seconds since 1970 of last garbage collection.                                    |                                        |
| go_memstats_lookups_total                              | Total number of pointer lookups.                                                            |                                        |
| go_memstats_mallocs_total                              | Total number of mallocs.                                                                    |                                        |
| go_memstats_mcache_inuse_bytes                         | Number of bytes in use by mcache structures.                                                |                                        |
| go_memstats_mcache_sys_bytes                           | Number of bytes used for mcache structures obtained from system.                            |                                        |
| go_memstats_mspan_inuse_bytes                          | Number of bytes in use by mspan structures.                                                 |                                        |
| go_memstats_mspan_sys_bytes                            | Number of bytes used for mspan structures obtained from system.                             |                                        |
| go_memstats_next_gc_bytes                              | Number of heap bytes when next garbage collection will take place.                          |                                        |
| go_memstats_other_sys_bytes                            | Number of bytes used for other system allocations.                                          |                                        |
| go_memstats_stack_inuse_bytes                          | Number of bytes in use by the stack allocator.                                              |                                        |
| go_memstats_stack_sys_bytes                            | Number of bytes obtained from system for stack allocator.                                   |                                        |
| go_memstats_sys_bytes                                  | Number of bytes obtained from system.                                                       |                                        |
| go_threads                                             | Number of OS threads created.                                                               |                                        |
| storageos_control_process_cpu_seconds_total            | Total user and system CPU time spent in seconds (Ondat control process)                 |                                        |
| storageos_control_process_major_faults_total           | Total number of major page faults initiated by the process (Ondat control process)      |                                        |
| storageos_control_process_max_fds                      | Maximum number of open file descriptors (Ondat control process)                         |                                        |
| storageos_control_process_open_fds                     | Number of open file descriptors (Ondat control process)                                 |                                        |
| storageos_control_process_resident_memory_bytes        | Resident memory size in bytes (Ondat control process)                                   |                                        |
| storageos_control_process_start_time_seconds           | Start time of the process since unix epoch in seconds (Ondat control process)           |                                        |
| storageos_control_process_sys_cpu_seconds_total        | Total system CPU time spent in seconds (Ondat control process)                          |                                        |
| storageos_control_process_threads_total                | Number of currently spawned threads (Ondat control process)                             |                                        |
| storageos_control_process_user_cpu_seconds_total       | Total user CPU time spent in seconds (Ondat control process)                            |                                        |
| storageos_control_process_virtual_memory_bytes         | Virtual memory size in bytes (Ondat control process)                                    |                                        |
| storageos_control_process_virtual_memory_max_bytes     | Maximum amount of virtual memory available in bytes (Ondat control process)             |                                        |
| storageos_dataplane_process_cpu_seconds_total          | Total user and system CPU time spent in seconds (Ondat dataplane process)               |                                        |
| storageos_dataplane_process_major_faults_total         | Total number of major page faults initiated by the process (Ondat dataplane process)    |                                        |
| storageos_dataplane_process_max_fds                    | Maximum number of open file descriptors (Ondat dataplane process)                       |                                        |
| storageos_dataplane_process_open_fds                   | Number of open file descriptors (Ondat dataplane process)                               |                                        |
| storageos_dataplane_process_resident_memory_bytes      | Resident memory size in bytes (Ondat dataplane process)                                 |                                        |
| storageos_dataplane_process_start_time_seconds         | Start time of the process since unix epoch in seconds (Ondat dataplane process)         |                                        |
| storageos_dataplane_process_sys_cpu_seconds_total      | Total system CPU time spent in seconds (Ondat dataplane process)                        |                                        |
| storageos_dataplane_process_threads_total              | Number of currently spawned threads (Ondat dataplane process)                           |                                        |
| storageos_dataplane_process_user_cpu_seconds_total     | Total user CPU time spent in seconds (Ondat dataplane process)                          |                                        |
| storageos_dataplane_process_virtual_memory_bytes       | Virtual memory size in bytes (Ondat dataplane process)                                  |                                        |
| storageos_dataplane_process_virtual_memory_max_bytes   | Maximum amount of virtual memory available in bytes (Ondat dataplane process)           |                                        |
| storageos_local_leader_detected_node_failed_total      | Number of nodes the leader attempted to mark as failed                                      |                                        |
| storageos_local_leader_known_nodes_sync_seconds_bucket | Time taken to synchronise known node list from data store                                   |                                        |
| storageos_local_leader_known_nodes_sync_seconds_count  | Total number of storageos_local_leader_known_nodes_sync_seconds_count                       |                                        |
| storageos_local_leader_known_nodes_sync_seconds_sum    | Total of all storageos_local_leader_known_nodes_sync_seconds_count                          |                                        |
| storageos_local_leader_known_nodes_total               | Number of nodes being actively monitored by this leader                                     |                                        |
| storageos_local_leader_volume_master_recover_total     | Number of master volumes the leader recovered                                               |                                        |
| storageos_node_device_capacity_bytes                   | Total device capacity usable by Ondat                                                   |                                        |
| storageos_node_device_free_bytes                       | Available device capacity usable by Ondat                                               |                                        |
| storageos_node_dp_config_sync_seconds_bucket           | Time taken to compare desired dataplane config state versus actual and apply differences    |                                        |
| storageos_node_dp_config_sync_seconds_count            | Total number of storageos_node_dp_config_sync_seconds                                       |                                        |
| storageos_node_dp_config_sync_seconds_sum              | Total of storageos_node_dp_config_sync_seconds                                              |                                        |
| storageos_node_volumes_total                           | Volumes on this node                                                                        |                                        |
| storageos_stats_process_cpu_seconds_total              | Total user and system CPU time spent in seconds (Ondat stats process)                   |                                        |
| storageos_stats_process_major_faults_total             | Total number of major page faults initiated by the process (Ondat stats process)        |                                        |
| storageos_stats_process_max_fds                        | Maximum number of open file descriptors (Ondat stats process)                           |                                        |
| storageos_stats_process_open_fds                       | Number of open file descriptors (Ondat stats process)                                   |                                        |
| storageos_stats_process_resident_memory_bytes          | Resident memory size in bytes (Ondat stats process)                                     |                                        |
| storageos_stats_process_start_time_seconds             | Start time of the process since unix epoch in seconds (Ondat stats process)             |                                        |
| storageos_stats_process_sys_cpu_seconds_total          | Total system CPU time spent in seconds (Ondat stats process)                            |                                        |
| storageos_stats_process_threads_total                  | Number of currently spawned threads (Ondat stats process)                               |                                        |
| storageos_stats_process_user_cpu_seconds_total         | Total user CPU time spent in seconds (Ondat stats process)                              |                                        |
| storageos_stats_process_virtual_memory_bytes           | Virtual memory size in bytes (Ondat stats process)                                      |                                        |
| storageos_stats_process_virtual_memory_max_bytes       | Maximum amount of virtual memory available in bytes (Ondat stats process)               |                                        |
| storageos_store_query_seconds_bucket                   | Data store query latency by operation type                                                  | May reveal problems with external etcd |
| storageos_store_query_seconds_count                    | Total number of storageos_store_query_seconds                                               |                                        |
| storageos_store_query_seconds_sum                      | Total of all storageos_store_query_seconds                                                  |                                        |
