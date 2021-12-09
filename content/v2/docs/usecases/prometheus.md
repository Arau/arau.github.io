---
title: Prometheus
---
<h1><img src="/images/docs/explore/prom.png" width="125" height="125"> Prometheus with Ondat</h1>

Prometheus is a popular application used for event monitoring and alerting in 
Kubernetes.

Before you start, ensure you have Ondat installed and ready on a Kubernetes
cluster. [See our guide on how to install Ondat on Kubernetes for more
information]({{< ref "docs/install/kubernetes.md" >}}).

## Deploying Prometheus on Kubernetes

This is the Prometheus use case for Ondat. Following are the steps
for creating a Prometheus instance and using Ondat to handle its
persistent storage.

1. You can find the latest files in the Ondat use cases repository
   ```bash
   git clone https://github.com/storageos/use-cases.git storageos-usecases
   ```

   Prometheus Custom Resource defintion
   ```yaml
    apiVersion: monitoring.coreos.com/v1
    kind: Prometheus
    metadata:
      name: prometheus-storageos
      labels:
        app: prometheus-operator
    spec:
      ...
      storage:
        volumeClaimTemplate:
          metadata:
            name: data
            labels:
              env: prod
        spec:
          accessModes: ["ReadWriteOnce"]
          storageClassName: ondat-replicated
          resources:
            requests:
              storage: 1Gi
    ```
   This excerpt is from the Prometheus Custom Resource definition. This file 
   contains the VolumeClaim template that will dynamically provision storage, 
   using the Ondat storage class. Dynamic provisioning occurs as a 
   volumeMount has been declared with the same name as a VolumeClaim.

1. Move into the Prometheus examples folder and create the objects

   ```bash
   $ cd storageos-usecases/prometheus
   $ ./install-prometheus.sh
   ```

1. Confirm Prometheus is up and running.

   ```bash
   $ kubectl get pods -w -l app=prometheus
   NAME                                READY   STATUS              RESTARTS   AGE
   prometheus-prometheus-storageos-0   3/3     READY               0          1m
   ```

1. You can see the created PVC using.
    ```bash
    $ kubectl get pvc
    NAME                                     STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS           AGE
    data-prometheus-prometheus-storageos-0   Bound    pvc-b6c17c0a-e76b-4a0b-8fc6-46c0e1629210   1Gi        RWO            ondat-replicated   65m
    ```

1. In the Prometheus deployment script, a service monitor is also created. 
The new Prometheus instance will use the storageos-etcd service monitor to 
start scraping metrics from the storageos-etcd pods. (Assuming the storageos 
cluster was setup using ETCD as pods) For more information about service 
monitors, have a look at the upstream [documentation](https://coreos.com/operators/prometheus/docs/latest/user-guides/getting-started.html).
    ```bash
    $ kubectl get servicemonitor                       
    NAME             AGE
    storageos-etcd   5d1h
    ```

1. Port forward in the prometheus pod to access the prom webapp.
   ```bash
   $ kubectl port-forward prometheus-prometheus-storageos-0 9090
   ```
   Then launch a web browser and type the url `localhost:9090` to access the 
   prometheus webapp. Confirm that prometheus is up and running there.

## Configuration

In the `storageos-usecases/prometheus/manifests/prometheus` directory exist examples of Service Monitors.
For more information at operating Prometheus, check out the [prometheus documentation](https://prometheus.io/docs/).
