{{ $cmd := .Get "cmd"}}
{{ $platforms := split ( .Get "platforms" ) "," }}
{{ $sched_version := .Get "sched_version" }}

## 3 Trigger a Ondat installation

{{ if eq (len $platforms) 1 }}
    {{- partial "content/customresource-v2.md" (dict "params" $.Params "platform" ( index  $platforms 0 )) -}}
{{ else }}
    {{ partial "content/operator-cr-tabs-v2.html" . }}
{{ end }}

> Additional `spec` parameters are available on the [Cluster Operator
> configuration]( {{ ref . "docs/reference/cluster-operator/configuration.md" }})
> page.

> You can find more examples such as deployments referencing a external etcd kv
> store for Ondat in the [Cluster Operator examples](
> {{ ref . "docs/reference/cluster-operator/examples.md" }}) page.

### Verify Ondat Installation

```bash
[root@master03]# {{ $cmd }} -n kube-system get pods -w
NAME                                    READY   STATUS    RESTARTS   AGE
storageos-csi-helper-5cf59b5b4-f5nwr    2/2     Running   0          3m
storageos-daemonset-75f6c               3/3     Running   0          3m
storageos-daemonset-czbqx               3/3     Running   0          3m
storageos-daemonset-zv4tq               3/3     Running   0          3m
storageos-scheduler-6d67b46f67-5c46j    1/1     Running   0          3m
```

> The above command watches the Pods created by the Cluster Definition example.
> Note that pods typically take approximately 65 seconds to enter the Running
> Phase.
