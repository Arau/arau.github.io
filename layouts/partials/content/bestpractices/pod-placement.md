## Ondat Pod placement

Ondat must run on all nodes that will contribute storage capacity to the
cluster or that will host Pods which use Ondat volumes. For production
environments, it is recommended to avoid placing Ondat Pods on Master
nodes.

Ondat is deployed with a DaemonSet controller, and therefore tolerates the
standard unschedulable (:NoSchedule) action. If that is the only taint placed
on master or cordoned nodes Ondat pods might start on them (see the
Kubernetes
[docs](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)
for more details). To avoid scheduling Ondat pods on master nodes, you can
add an arbitrary taint to them for which the Ondat DaemonSet won't have a
toleration.
