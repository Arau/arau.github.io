---
title: Metrics
linkTitle: Metrics
---


Ondat believes in exposing many metrics about the functioning and
performance of Ondat processes to help users instrument applications
consuming Ondat volumes and Ondat itself. To this end Ondat exposes
metrics via a Prometheus endpoint on each Ondat pod. See our [Prometheus
Endpoint](/docs/reference/prometheus) reference page for specific details about
what metrics are exposed.

Ondat metrics are exposed in [Prometheus text
format](https://prometheus.io/docs/instrumenting/exposition_formats/#text-based-format),
so collectors such as [Prometheus](https://prometheus.io),
[Telegraf](https://www.influxdata.com/time-series-platform/telegraf/) or
[Sensu](https://sensu.io/) can be used. Prometheus text format exposes data as
time series where each time series can be one of four [Prometheus metric
types](https://prometheus.io/docs/concepts/metric_types/).


| Metric Name | Description                                                                   | Example Metric                                  |
| ----------- | ------------                                                                  | --------------                                  |
| Counter     | Cumulative metric that only increases. Can be reset to zero on a restart      | storageos_volume_backend_read_bytes_total       |
| Gauge       | Metric that can increase or decrease                                          | storageos_volume_size_bytes                     |
| Histogram   | Cumulative metric that includes information about the distribution of samples | storageos_local_leader_known_nodes_sync_seconds |
| Summary     | Similar to a histogram but calculates quantiles over certain time windows     | go_gc_duration_second                           |

Each time series is identified by a metric name and [key-value
labels](http://opentsdb.net/overview.html). The key-value labels allow multiple
dimensions for a metric to be exposed. For example the
`storageos_volume_backend_read_bytes_total` metric is given for each volume.

Using Prometheus to scrape metrics endpoints in Kubernetes is quite elegant as
Prometheus can be configured to scrape metrics from Kubernetes Services. This
is important because Ondat metrics are intended to be scraped from every
Ondat pod in the cluster and then aggregated.

For an example of how to visualize Ondat metrics please see our [Monitoring
Ondat page](/docs/operations/monitoring#analysing-metrics) for a link to a
sample Grafana dashboard.
