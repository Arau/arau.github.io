{{ $sched_version := .Get "sched_version" }}

{{- if ge $sched_version 4.0 }}
## 5. Set SELinux Permissions

The Ondat CSI helper needs to mount a CSI Socket into the container so
on each node add the `svirt_sandbox_file_t` flag to the CSI socket directory
and CSI socket.

   ```
   chcon -Rt svirt_sandbox_file_t /var/lib/kubelet/plugins_registry/storageos
   ```
{{-  end }}
