{{ $cmd := .Get "cmd"}}

## 1. Install Ondat operator

Install the Ondat Cluster Operator using the following yaml manifest.

```bash
{{ $cmd }} create -f https://github.com/storageos/cluster-operator/releases/download/{{ .Site.Params.latest_operator_version }}/storageos-operator.yaml
```


### Verify the Cluster Operator Pod Status

```bash
[root@master03]# {{ $cmd }} -n storageos-operator get pod
NAME                                         READY     STATUS    RESTARTS   AGE
storageoscluster-operator-68678798ff-f28zw   1/1       Running   0          3m
```

> The READY 1/1 indicates that `storageoscluster` resources can be created.
