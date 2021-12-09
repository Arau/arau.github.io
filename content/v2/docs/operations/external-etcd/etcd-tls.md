---
linkTitle: mTLS
title: Encrypting communication with Etcd
---


Ondat supports secure communication with an external etcd cluster using
mutual TLS (mTLS). With mTLS both Ondat and etcd authenticate each other
ensuring that communication only happens between mutually authenticated end
points, and that all communication is encrypted.

Ondat uses [environment variables](/docs/reference/envvars) to specify the
location of the necessary certificates and keys. This allows Kubernetes secrets
to be mounted as volumes, directly into pods.

## Setting up mTLS with Etcd

Below is an example StorageOSCluster resource that can be used to setup
Ondat with etcd using mTLS.

```yaml
apiVersion: storageos.com/v1
kind: StorageOSCluster
metadata:
  name: storageos-cluster
  namespace: "default"
spec:
  images:
    nodeContainer: "storageos/node:{{< param latest_node_version >}}"
  secretRefName: "storageos-api"
  secretRefNamespace: "default"
  namespace: "storageos"
  csi:
    enable: true
    deploymentStrategy: "deployment"
    enableControllerPublishCreds: true
    enableNodePublishCreds: true
    enableProvisionCreds: true
  # External mTLS secured etcd cluster specific properties
  tlsEtcdSecretRefName: "etcd-client-tls"                          # Secret containing etcd client certificates
  tlsEtcdSecretRefNamespace: "etcd"                                # Namespace of the client certificates secret
  kvBackend:
    address: "https://storageos-etcd-cluster-client.storageos-etcd.svc:2379" # Etcd client service address.
    backend: "etcd"                                                # Backend type
```

`tlsEtcdSecretRefName` and `tlsEtcdSecretRefNamespace` are used to pass a
reference to a secret that should contain the following key:values:
* etcd-client-ca.crt - containing the etcd Certificate Authority certificate
* etcd-client.crt - containing the etcd Client certificate
* etcd-client.key - cotaining the etcd Client key

The Ondat operator uses the etcd secret that contains the client
certificates, to build a secret in the Ondat installation namespace. This
secret contains the certificate filenames and certificate file contents. The
Ondat daemonset that is created by the operator mounts the secret as a
volume so that the certificate files are avaliable inside the pod. Environment
variables containing the file paths are passed to the Ondat process in
order to use the files from the mounted path.

A worked example of settings up Ondat with external etcd using mTLS is avaliable
[here](https://github.com/storageos/deploy/tree/master/k8s/deploy-storageos/etcd-helpers/etcd-operator-example-with-tls).
For ease of use the example uses the CoreOS etcd operator and the CoreOS guide
for [Cluster
TLS](https://github.com/coreos/etcd-operator/blob/master/doc/user/cluster_tls.md)
is followed.
