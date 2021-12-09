{{- $cmd := .params.cmd -}}
{{- $sched_version := .params.sched_version -}}
{{- $platform := .platform -}}

This is a Cluster Definition example.

```bash
apiVersion: "storageos.com/v1"
kind: StorageOSCluster
metadata:
  name: "example-ondat"
  namespace: "storageos-operator"
spec:
{{- if not (eq $platform "openshift") }}
  # Ondat Pods are in kube-system by default
{{- end }}
  secretRefName: "storageos-api" # Reference from the Secret created in the previous step
  secretRefNamespace: "storageos-operator"  # Namespace of the Secret
  k8sDistro: "{{ $platform }}"
  images:
    nodeContainer: "storageos/node:{{ site.Params.latest_node_version }}" # Ondat version
  kvBackend:
    address: 'storageos-etcd-client.storageos-etcd:2379' # Example address, change for your etcd endpoint
  # address: '10.42.15.23:2379,10.42.12.22:2379,10.42.13.16:2379' # You can set ETCD server ips
{{- if eq $platform "dockeree" }}
  sharedDir: '/var/lib/kubelet/plugins/kubernetes.io~storageos' # Needed when Kubelet as a container
{{- end }}
  resources:
    requests:
      memory: "512Mi"
      cpu: 1
#  nodeSelectorTerms:
#    - matchExpressions:
#      - key: "node-role.kubernetes.io/worker" # Compute node label will vary according to your installation
#        operator: In
#        values:
#        - "true"
```
