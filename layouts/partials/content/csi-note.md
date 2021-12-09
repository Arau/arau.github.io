## CSI (Container Storage Interface) Note

CSI is the standard method of communication that enables storage drivers for
Kubernetes to release on their own schedule. The CSI standard allows storage
vendors to upgrade, update, and enhance their drivers without the need to
update Kubernetes source code, or follow Kubernetes release cycles.

CSI was released GA from Kubernetes 1.13. Ondat v2 only supports the use of
CSI as a storage driver. In addition, the Ondat Cluster Operator handles
the configuration of the CSI driver and its complexity by detecting the version
of the Kubernetes installed.

Check out the status of the CSI release cycle in relation with Kubernetes in
the [CSI project](https://kubernetes-csi.github.io/docs/) page.

CSI communication is fully supported by Ondat if the cluster is deployed
with any [supported Linux
Distribution](/docs/prerequisites/systemconfiguration#distribution-specifics).
