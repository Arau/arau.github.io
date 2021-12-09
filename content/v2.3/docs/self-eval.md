---
title: "Self Evaluation Guide"
linkTitle: "Self Evaluation Guide"
weight: 900
description: >
  Step-by-step guide to installing and evaluating Ondat
---

Our self-evaluation guide is a step by step recipe for installing and testing
Ondat. This guide is divided into three sections:

* __Installation__ - install Ondat with a single command
* __Feature Testing__ - short walkthrough of some of our features
* __Benchmarking__ - a recipe to benchmark Ondat on your infrastructure

For more comprehensive documentation including installation advice for complex
setups, operational guides, and use-cases, please see our main [documentation
site]({{< ref "docs" >}}).

## Support for Self Evaluations

Should you have questions or require support, there are several ways to get in
touch with us. The fastest way to get in touch is to [join our public Slack
channel](https://slack.storageos.com). You can also get in touch via email to
[info@storageos.com](mailto:support@storageos.com).

Furthermore you can fill out the form below and we will get in touch.

## Get Started Now

<script charset="utf-8" type="text/javascript"
src="//js.hsforms.net/forms/v2.js"></script>

<script>

hbspt.forms.create({

   portalId: "3402546",
   formId: "a07fecd3-ce5b-4835-b136-51a94a35632b",
   sfdcCampaignId: "70158000000BAZzAAO"
});
</script>

&nbsp;

# Installation

In this document we detail a simple installation suitable for evaluation
purposes. The etcd we install uses a 3 node cluster with ephemeral storage, and
as such is not suitable for production workloads. However, for evaluation
purposes it should be sufficient. For production deployments, please see our
main [documentation pages]({{< ref "docs/prerequisites/etcd.md" >}}).

A standard Ondat installation uses the Ondat operator, which performs
most platform-specific configuration for you. The Ondat operator has been
certified by [Red Hat](https://storageos.com/red-hat/) and is [open
source](https://github.com/storageos/cluster-operator).

The basic installation steps are:

* Check prerequisites
* Install an etcd cluster
* Install the [Ondat Operator]({{< ref "docs/reference/cluster-operator"
    >}})
* Install Ondat by applying a CR for the Operator to action

## <a name='Prerequisites'></a>Prerequisites

While we do not require custom kernel modules or additional userspace tooling,
Ondat does have a few basic prerequisites that are met by default by most
modern distributions:

* At least 1 CPU core, 2GB RAM free.
* A Kubernetes release within the four most recent versions.
* TCP ports 5701-5710 and TCP & UDP 5711 open between all nodes in the cluster.
* A 64bit supported operating system - Ondat can run without additional
  packages in Debian 9, RancherOS, RHEL7.5,8 and CentOS7,8 and need the package
  linux-image-extra for Ubuntu.
* Mainline kernel modules `target_core_mod`, `tcp_loop`, `target_core_file`,
  `target_core_user`, `configfs`, and `ui`. These are present by default on
  most modern linux distributions, and can be installed with standard package
  managers. See our [system configuration](
  {{<ref "docs/prerequisites/systemconfiguration" >}}) page for instructions.

## <a name='Quick Installation'></a>Quick Installation

For those feeling brave and/or lucky, we have encapsulated the installation
instructions in this guide into a short bash script. As with similar
instructions elsewhere on the internet, caution is advised here. The script is
liberally commented and we recommend that you inspect it in your text editor of
choice before running.

> Run the following command where `kubectl` is installed and with the context
> set for your Kubernetes cluster

```bash
curl -sL https://storageos.run | bash
```

Note that this script deploys a cluster with etcd on transient storage,
__suitable for evaluation purposes only__. Do not use this cluster for
production workloads.

Your new cluster can be used straight away. You can now jump to the
[Provision a Volume]({{< ref "docs/self-eval.md"
>}}#StorageOSVolume) section below to provision your first volume and license
the cluster.

## <a name='StepByStep'></a>Installing Ondat Step By Step

This section describes the installation steps in some more detail.

### <a name='Installetcd'></a>Install etcd

Here we install a 3 node etcd cluster using the CoreOS operator to install on
ephemeral storage within your Kubernetes cluster. This is suitable for
evaluation purposes. For production deployment instructions, please see our
[production etcd]({{< ref "docs/prerequisites/etcd" >}}) page.

1. Download repo

    ```bash
    $ git clone https://github.com/coreos/etcd-operator.git
    ```

1. Configure NS, Role and RoleBinding

    ```bash
    $ export ROLE_NAME=etcd-operator
    $ export ROLE_BINDING_NAME=etcd-operator
    $ export NAMESPACE=etcd
    ```

1. Create Namespace

    ```bash
    $ kubectl create namespace $NAMESPACE
    ```

1. Deploy Operator

    ```bash
    $ ./etcd-operator/example/rbac/create_role.sh
    $ kubectl -n $NAMESPACE create -f - <<END
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: etcd-operator
    spec:
      selector:
        matchLabels:
          app: etcd-operator
      replicas: 1
      template:
        metadata:
          labels:
            app: etcd-operator
        spec:
          containers:
          - name: etcd-operator
            image: quay.io/coreos/etcd-operator:v0.9.4
            command:
            - etcd-operator
            env:
            - name: MY_POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
            - name: MY_POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
    END
    ```

1. Create the EtcdCluster resource

    ```bash
   $ kubectl -n $NAMESPACE create -f - <<YAML
   apiVersion: "etcd.database.coreos.com/v1beta2"
   kind: "EtcdCluster"
   metadata:
     name: "storageos-etcd"
   spec:
     size: 3 # Set to 1 if insufficient nodes
     version: "3.4.7"
     pod:
       etcdEnv:
       - name: ETCD_QUOTA_BACKEND_BYTES
         value: "2147483648"  # 2 GB 
       - name: ETCD_AUTO_COMPACTION_RETENTION
         value: "1000" # Keep 1000 revisions
       - name: ETCD_AUTO_COMPACTION_MODE
         value: "revision" # Set the revision mode
       resources:
         requests:
           cpu: 200m
           memory: 300Mi
       securityContext:
         runAsNonRoot: true
         runAsUser: 9000
         fsGroup: 9000
       tolerations:
       - operator: "Exists" # add tolerations to match all taints on the master nodes where etcd will be deployed
       affinity:
         podAntiAffinity:
           preferredDuringSchedulingIgnoredDuringExecution:
           - weight: 100
             podAffinityTerm:
               labelSelector:
                 matchExpressions:
                 - key: etcd_cluster
                   operator: In
                   values:
                   - storageos-etcd
               topologyKey: kubernetes.io/hostname
   YAML
   ```
This creates a 3 node etcd cluster and associated service in Kubernetes. We can
use the service endpoint when creating the Ondat cluster.

## <a name='InstallStorageOSOperator'></a>Install Ondat Operator

In order to install the Ondat operator download the requisite yaml
manifests or apply them with kubectl.

```bash
$ kubectl create -f https://github.com/storageos/cluster-operator/releases/download/{{< param latest_operator_version >}}/storageos-operator.yaml
```

You can verify the operator is running using the following command

```bash
$ kubectl get pods -n storageos-operator
```

&nbsp;

## <a name='InstallStorageOS'></a>Install Ondat

Once the Ondat operator has been installed a Ondat cluster can be
generated by creating a StorageOSCluster resource.

A StorageOSCluster resource describes the state of the Ondat cluster that
is desired and the Ondat operator will create the desired Ondat
cluster. For examples of StorageOSCluster resources please see our examples
page
[here](https://docs.storageos.com/docs/reference/cluster-operator/examples).
For a full list of the configurable `spec` parameters of the StorageOSCluster
resource please see
[here](https://docs.storageos.com/docs/reference/cluster-operator/configuration).

1. Create a secret defining the API username and password

    ```yaml
   $ kubectl create -f - <<END
   apiVersion: v1
   kind: Secret
   metadata:
     name: "storageos-api"
     namespace: "storageos-operator"
     labels:
       app: "storageos"
   type: "kubernetes.io/storageos"
   data:
     # echo -n '<secret>' | base64
     apiUsername: c3RvcmFnZW9z
     apiPassword: c3RvcmFnZW9z
     # CSI Credentials
     csiProvisionUsername: c3RvcmFnZW9z
     csiProvisionPassword: c3RvcmFnZW9z
     csiControllerPublishUsername: c3RvcmFnZW9z
     csiControllerPublishPassword: c3RvcmFnZW9z
     csiNodePublishUsername: c3RvcmFnZW9z
     csiNodePublishPassword: c3RvcmFnZW9z
     csiControllerExpandUsername: c3RvcmFnZW9z
     csiControllerExpandPassword: c3RvcmFnZW9z
   END
    ```

1. Create a StorageOSCluster resource

    ```yaml
   $ kubectl create -f - <<END
   apiVersion: storageos.com/v1
   kind: StorageOSCluster
   metadata:
     name: example-ondatcluster
     namespace: "storageos-operator"
   spec:
     # Ondat Pods are in kube-system by default
     secretRefName: "storageos-api"
     secretRefNamespace: "storageos-operator"
     k8sDistro: "upstream"  # Set the Kubernetes distribution for your cluster (upstream, eks, aks, gke, rancher, dockeree)
     # storageClassName: fast # The storage class creates by the Ondat operator is configurable
     kvBackend:
       address: "storageos-etcd-client.etcd.svc.cluster.local:2379"
   END
    ```

1. Confirm that the cluster has been created and that Ondat pods are
   running

    ```bash
    $ kubectl -n kube-system get pods
    ```

   Ondat pods enter a ready state after a minimum of 45s has passed.

1. Deploy the Ondat CLI as a container

    ```bash
    $ kubectl -n kube-system run \
    --image storageos/cli:{{< param latest_cli_version >}} \
    --restart=Never                          \
    --env STORAGEOS_ENDPOINTS=storageos:5705 \
    --env STORAGEOS_USERNAME=storageos       \
    --env STORAGEOS_PASSWORD=storageos       \
    --command cli                            \
    -- /bin/sh -c "while true; do sleep 999999; done"
    ```


## <a name='StorageOSVolume'></a>Provision a Ondat Volume

Now that we have a working Ondat cluster, we can provision a volume to test
everything is working as expected.

1. Create a PVC

    ```bash
    $ kubectl create -f - <<END
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: pvc-1
    spec:
      storageClassName: "fast"
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 5Gi
    END
    ```

1. Verify that the volume was created with the CLI

    >`pvc-1` should be listed in the CLI output

      ```bash
      $ kubectl -n kube-system exec -it cli -- storageos get volumes
      ```

1. Create a pod that consumes the PVC

    ```bash
   $ kubectl create -f - <<END
   apiVersion: v1
   kind: Pod
   metadata:
     name: d1
   spec:
     containers:
       - name: debian
         image: debian:9-slim
         command: ["/bin/sleep"]
         args: [ "3600" ]
         volumeMounts:
           - mountPath: /mnt
             name: v1
     volumes:
       - name: v1
         persistentVolumeClaim:
           claimName: pvc-1
   END
    ```

1. Check that the pod starts successfully. If the pod starts successfully then
   the Ondat cluster is working correctly

    ```bash
    $ kubectl get pod d1 -w
    ```

    The pod mounts a Ondat volume under `/mnt` so any files written there
    will persist beyond the lifetime of the pod. This can be demonstrated using
    the following commands.

1. Execute a shell inside the pod and write some data to a file

    ```bash
    $ kubectl exec -it d1 -- bash
    root@d1:/# echo Hello World! > /mnt/hello
    root@d1:/# cat /mnt/hello
    ```

    >`Hello World!` should be printed out.

1. Delete the pod

    ```bash
    $ kubectl delete pod d1
    ```

1. Recreate the pod

    ```bash
   $ kubectl create -f - <<END
   apiVersion: v1
   kind: Pod
   metadata:
     name: d1
   spec:
     containers:
       - name: debian
         image: debian:9-slim
         command: ["/bin/sleep"]
         args: [ "3600" ]
         volumeMounts:
           - mountPath: /mnt
             name: v1
     volumes:
       - name: v1
         persistentVolumeClaim:
           claimName: pvc-1
   END
    ```

1. Open a shell inside the pod and check the contents of `/mnt/hello`

    ```bash
    $ kubectl exec -it d1 -- cat /mnt/hello
    ```

    >`Hello World!` should be printed out.

## <a name='LicenseCluster'></a>License cluster

Newly installed Ondat clusters must be licensed within 24 hours. Our
personal license is free, and supports up to 1TiB of provisioned storage.

You will need access to the Ondat API on port 5705 of any of your nodes.
For convenience, it is often easiest to port forward the service using the
following kubectl incantation (this will block, so a second terminal window may
be advisable):

  ```bash
  $ kubectl port-forward -n kube-system svc/storageos 5705
  ```
Now follow the instructions on our [operations licensing]({{< ref
"docs/operations/licensing.md" >}}) page to obtain and apply a license.

Installation of Ondat is now complete.

# <a name='StorageOSFeatures'></a>Ondat Features

Now that you have a fully functional Ondat cluster we will explain
some of our features that may be of use to you as you complete application and
synthetic benchmarks.

Ondat features are all enabled/disabled by applying labels to volumes.
These labels can be passed to Ondat via persistent volume claims (PVCs) or
can be applied to volumes using the Ondat CLI or GUI.

The following is not an exhaustive feature list but outlines features which are
commonly of use during a self-evaluation.

## <a name='VolumeReplication'></a>Volume Replication

Ondat enables synchronous replication of volumes using the
`storageos.com/replicas` label.

The volume that is active is referred to as the master volume. The master
volume and its replicas are always placed on separate nodes. In fact if a
replica cannot be placed on a node without a replica of the same volume, the
volume will fail to be created. For example, in a three node Ondat cluster
a volume with 3 replicas cannot be created as the third replica cannot be
placed on a node that doesn't already contain a replica of the same volume.

See our [replication
documentation](https://docs.storageos.com/docs/concepts/replication) for more
information on volume replication.

1. To test volume replication create the following PersistentVolumeClaim

    ```bash
   $ kubectl create -f - <<END
   apiVersion: v1
   kind: PersistentVolumeClaim
   metadata:
     name: pvc-replicated
     labels:
       storageos.com/replicas: "1"
   spec:
     storageClassName: "fast"
     accessModes:
     - ReadWriteOnce
     resources:
       requests:
         storage: 5Gi
   END
    ```

    > Note that volume replication is enabled by setting the
    > `storageos.com/replicas` label on the volume.

1. Confirm that a replicated volume has been created by using the Ondat CLI
   or UI

    ```bash
    $ kubectl -n kube-system exec -it cli -- storageos get volumes
    ```


1. Create a pod that uses the PVC

    ```bash
    $ kubectl create -f - <<END
    apiVersion: v1
    kind: Pod
    metadata:
      name: replicated-pod
    spec:
      containers:
       - name: debian
         image: debian:9-slim
         command: ["/bin/sleep"]
         args: [ "3600"  ]
         volumeMounts:
           - mountPath: /mnt
             name: v1
      volumes:
       - name: v1
         persistentVolumeClaim:
           claimName: pvc-replicated
    END
    ```

1. Write data to the volume

    ```bash
    $ kubectl exec -it replicated-pod -- bash
    root@replicated-pod:/# echo Hello World! > /mnt/hello
    root@replicated-pod:/# cat /mnt/hello
    ```

    >`Hello World!` should be printed out.

1. Find the location of the master volume and shutdown the node

    Shutting down a node causes all volumes, with online replicas, on the node
    to be evicted. For replicated volumes this immediately promotes a replica
    to become the new master.

    ```bash
    $ kubectl get pvc
    NAME           STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
    pvc-replicated Bound    pvc-29e2ad6e-8c4e-11e9-8356-027bfbbece86   5Gi        RWO            fast           1m

    $ kubectl exec -it -n kube-system cli -- storageos get volumes
    NAMESPACE  NAME                                      SIZE     LOCATION              ATTACHED ON   REPLICAS  AGE
    default    pvc-4e796a62-0271-45f9-9908-21d58789a3fe  5.0 GiB  kind-worker (online)  kind-worker2  1/1       26 seconds ago

    ```

1. Check the location of the master volume and notice that it is on a new node.
   If the pod that mounted the volume was located on the same node that was
   shutdown then the pod will need to be recreated.

    ```bash
    $ kubectl exec -it -n kube-system cli -- storageos get volumes
    NAMESPACE  NAME                                      SIZE     LOCATION               ATTACHED ON   REPLICAS  AGE
    default    pvc-4e796a62-0271-45f9-9908-21d58789a3fe  5.0 GiB  kind-worker2 (online)  kind-worker2  1/1       46 seconds ago
    ```

1. Check that the data is still accessible to the pod

    ```bash
    $ kubectl exec -it replicated-pod -- bash
    root@replicated-pod:/# cat /mnt/hello
    ```

    >`Hello World!` should be printed out.

&nbsp;
# <a name='Benchmarking'></a>Benchmarking

Benchmarking storage is a complex topic. Considering the many books and papers
that have been written about benchmarking, we could write many paragraphs here
and only begin to scratch the surface.

Taking this complexity into account we present recipes for both synthetic
benchmarks using [FIO](https://github.com/axboe/fio), and a sample application
benchmark to test PostgreSQL using
[pgbench](https://www.postgresql.org/docs/current/pgbench.html). The approaches
are complementary - synthetic benchmarks allow us to strictly control the
parameters of the IO we put through the system in order to stress various
aspects of it. Application benchmarks allow us to get a sense of the
performance of the system when running an actual representative workload -
which of course is the ultimate arbiter of performance.

Despite the inherent complexity of benchmarking storage there are a few general
considerations to keep in mind.

## <a name='Considerations'></a>Considerations

### <a name='VolumePlacement'></a>Local vs. Remote Volumes

When a workload is placed on the same node as a volume, there is no network
round trip for IO, and performance is consequently improved. When considering
the performance of Ondat it is important to evaluate both local and remote
volumes; since for certain workloads we want the high performance of a local
attachment, but we also desire the flexibility of knowing that our less
performance-sensitive workloads can run from any node in the cluster.

### <a name='Replication'></a>The Effect of Synchronous Replication

Synchronous replication does not impact the read performance of a volume, but
it can have a significant impact on the write performance of the volume, since
all writes must be propagated to replicas before being acked to the
application. The impact varies in proportion to the inter-node latency. For an
inter-node latency of 1ms, we have a max ceiling of 1000 write IOPS, and in
reality a little less than that to allow for processing time on the nodes. This
is less concerning then it may first appear, since many applications will issue
multiple writes in parallel (known as increasing the queue depth).

## <a name='SyntheticBenchmarks'></a>Synthetic Benchmarks

### Prerequisites

* Kubernetes cluster with a minimum of 3 nodes and a minimum of
30 Gb available capacity
* Ondat CLI running as a pod in the cluster

Synthetic benchmarks using tools such as FIO are a useful way to begin
measuring Ondat performance. While not fully representative of application
performance, they allow us to reason about the performance of storage devices
without the added complexity of simulating real world workloads, and provide
results easily comparable across platforms.

FIO has a number of parameters that can be adjusted to simulate a variety of
workloads and configurations. Parameters that are particularly important are:

* **Block Size** - the size of the IO units performed.
* **Queue Depth** - the amount of concurrent IOs in flight
* **IO Pattern** - access can be random across the disk, or sequentially. IO
    subsystems typically perform better with sequential IO, because of the
    effect of read ahead caches, and other factors

For this self-evaluation we will run a set of tests based on the excellent
[DBench](https://github.com/leeliu/dbench), which distills the numerous FIO
options into a series of well-crafted scenarios:

* **Random Read/Write IOPS and BW** - these tests measure the IOPS ceiling
  (with a 4k block size) and bandwidth ceiling (with a 128K block size) of the
  volume using a random IO pattern and high queue depth
* **Average Latency** - these tests measure the IO latency of the volume under
  favourable conditions using a random access pattern, low queue depth and low
  block size
* **Sequential Read/Write** - these tests measure the sequential read/write
  throughput of the volume with a high queue depth and high block size
* **Mixed Random Read/Write IOPS** - these tests measure the performance of the
    volume under a 60/40 read/write workload using a random access pattern and
    low blocksize

For convenience we present a single script to run the scenarios using local and
remote volumes both with and without a replica. Deploy the FIO tests for the
four scenarios using the following command:

  ```bash
  curl -sL {{% baseurl %}}/sh/deploy-synthetic-benchmarks.sh | bash
  ```

The script will take approximately 20 minutes to complete, and will print the
results to STDOUT.

The exact results observed will depend on the particular platform and
environment, but the following trends should be observable:

* local volumes perform faster than remote volumes
* read performance is independent of the number of replicas
* write performance is dependent on the number of replicas

## <a name='ApplicationBenchmarks'></a>Application Benchmarks

While synthetic benchmarks are useful for examining the behaviour of Ondat
with very specific workloads, in order to get a realistic picture of Ondat
performance actual applications should be tested.

Many applications come with test suites which provide standard workloads. For
best results, test using your application of choice with a representative
configuration and real world data.

As an example of benchmarking an application the following steps lay out how to
benchmark a Postgres database backed by a Ondat volume.

1. Start by cloning the Ondat use cases repository. Note this is the same
   repository that we cloned earlier so if you already have a copy just `cd
   storageos-usecases/pgbench`.

    ```bash
    $ git clone https://github.com/storageos/use-cases.git storageos-usecases
    ```

1. Move into the Postgres examples folder

    ```bash
    $ cd storageos-usecases/pgbench
    ```

1. Decide which node you want the pgbench pod and volume to be located on. The
   node needs to be labelled `app=postgres`

    ```bash
    $ kubectl label node <NODE> app=postgres
    ```

1. Then set the `storageos.com/hint.master` label in
   20-postgres-statefulset.yaml file to match the Ondat nodeID for the node
   you have chosen before creating all the files. The Ondat nodeID can be
   obtained using the cli and doing a `describe node`

    ```bash
    $ kubectl create -f .
    ```

1. Confirm that Postgres is up and running

    ```bash
    $ kubectl get pods -w -l app=postgres
    ```

1. Use the Ondat CLI or the GUI to check the master volume location and the
   mount location. They should match

    ```bash
    $ kubectl -n kube-system exec -it cli -- storageos get volumes
    ```

1. Exec into the pgbench container and run pgbench

    ```bash
    $ kubectl exec -it pgbench -- bash -c '/opt/cpm/bin/start.sh'
    ```

&nbsp;
# <a name='Conclusion'></a>Conclusion

After completing these steps you will have benchmark scores for Ondat.
Please keep in mind that benchmarks are only part of the story and that there
is no replacement for testing actual production or production like workloads.

Ondat invites you to provide feedback on your self-evaluation to the [slack
channel](https://storageos.slack.com) or by directly emailing us at
<info@storageos.com>]
