{{ $platform := .Get "platform" }}

## Kubernetes with Ondat

Ondat integrates transparently with Kubernetes and different distributions
such as OpenShift, Rancher, EKS, AKS, GKE, etc. The user can provide standard
PVC definitions and Ondat will dynamically provision matching volumes.
Ondat presents volumes to containers with standard POSIX mount targets.
This enables the Kubelet to mount Ondat volumes using standard linux device
files. Checkout [device presentation](
{{ ref . "docs/concepts/volumes.md" }}) for more details.

Kubernetes and Ondat communicate with each other to perform actions such as
creation, deletion or mounting of volumes. The CSI (Container Storage
Interface) driver is the standard method of communication. Using CSI,
Kubernetes and Ondat communicate over a Unix domain socket.

It is recommended to use the CSI Ondat installation from Kubernetes 1.13
onwards. Although the former communication procedure, the native driver, is
still in use and Ondat maintains support for it, its use is discouraged as
it is a deprecated method, to be removed in newer versions of Kubernetes.

{{- if or (eq $platform "azure-aks") (eq $platform "aws-eks") }}
For {{ $platform }} platform the **only supported** setup for communication is **CSI**.
{{- end }}



