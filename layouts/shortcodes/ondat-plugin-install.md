## Install Ondat

```bash
kubectl storageos install \
    --etcd-endpoints 'storageos-etcd-client.storageos-etcd:2379' \
    --admin-username "myuser" \
    --admin-password "my-password"
```

> Define the etcd endpoints as a comma delimited list, e.g. 10.42.3.10:2379,10.42.1.8:2379,10.42.2.8:2379

> If the etcd endpoints are not defined, the plugin will promt you and
> request the endpoints.
