Kubernetes allows the use of different schedulers by setting the field
`.spec.schedulerName: storageos-scheduler`.

For instance a Pod manifest utilising the Ondat scheduler would appear as follows:

```bash
apiVersion: v1
kind: Pod
metadata:
  name: d1
spec:
  schedulerName: storageos-scheduler # --> Ondat Scheduler
                                     # No need if using Admission Controller
                                     # (enabled by default)
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
        claimName: persistent-volume # ----> Ondat PVC

```
