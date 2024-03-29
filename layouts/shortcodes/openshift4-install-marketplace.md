{{ $version := .Get "sched_version" }}
{{ $platform := .Get "platform" }}

> The installation of Ondat using the Red Hat Marketplace requires the
> Openshift cluster to be registered to the Marketplace Portal, including the
> roll out of the PullSecret in your cluster. Failure to do so will result in a
> image pull authentication failure with the Red Hat registry.

1. Select the `OperatorHub` from the Catalog sub menu and search for Ondat.

    ![install-0](/images/openshift4/marketplace/1.png)

   > Choose the RedHat Marketplace option.

1. Select Ondat and click purchase. Note that Openshift needs to be
   registered with the Red Hat Marketplace portal.

    ![install-1](/images/openshift4/marketplace/2.png)

1. Select the most suitable install option.

    ![install-2](/images/openshift4/marketplace/3.png)

    > Project Edition is suitable for production workloads, Developer Edition
    > for personal experimentation and evaluation.

1. Specify the product configuration to fit your needs.

    ![install-3](/images/openshift4/marketplace/4.png)

1. Navigate to your software within Red Hat Marketplace and install the
   Ondat software as specified in the image.

    ![install-4](/images/openshift4/marketplace/5.png)

1. Install the Operator. Set the update approval strategy to Automatic to
   ensure that you always have the latest version of Ondat installed.

    ![install-5](/images/openshift4/marketplace/6.png)

1. The Ondat Cluster Operator is installed into your specified cluster.

    ![install-6](/images/openshift4/marketplace/7.png)

1. Create a Secret in the `openshift-operators` project

    ![install-7](/images/openshift4/storageos-v2/070-create-secret.png)

1. Use the YAML options to create a secret containing the `apiUsername` and an
   `apiPassword` key. The username and password defined in the secret will be
   used to authenticate when using the Ondat CLI and GUI. For the
   communication between Ondat and OpenShift, the CSI credentials
   `csiProvisionUsername`, `csiProvisionPassword`,
   `csiControllerPublishUsername`, `csiControllerPublishPassword`,
   `csiNodePublishUsername`, `csiNodePublishPassword` are needed. Take note of
   which project you created the secret in.

    Input the Secret as YAML for simplicity.

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: storageos-api
      namespace: openshift-operators
    type: "kubernetes.io/storageos"
    data:
      # echo -n '<secret>' | base64
      apiUsername: c3RvcmFnZW9z
      apiPassword: c3RvcmFnZW9z
      # CSI Credentials
      csiProvisionUsername: c3RvcmFnZW9z
      csiProvisionPassword: c3RvcmFnZW9z
      csiControllerPublishUsername: c3RvcmFnZW9z
      csiControllerPublishPassword: c3RvcmFnZW9z
      csiNodePublishUsername: c3RvcmFnZW9z
      csiNodePublishPassword: c3RvcmFnZW9z
      csiControllerExpandUsername: c3RvcmFnZW9z
      csiControllerExpandPassword: c3RvcmFnZW9z
    ```
    ![install-8](/images/openshift4/storageos-v2/080-create-secret-yaml.png)

1. Go to Ondat in your "Installed Operators"

    ![install-9](/images/openshift4/marketplace/8.png)

    > Verify that the Ondat Cluster Operator is installed

1. Go to the "Ondat Cluster" section

    ![install-10](/images/openshift4/storageos-v2/100-operator-details.png)


1. Create the Ondat Cluster

    ![install-11](/images/openshift4/storageos-v2/110-create-storageos-cluster.png)

    > A Ondat Cluster is defined using a Custom Resource Definition

1. Create the Custom Resource

   The Ondat cluster resource describes the Ondat cluster that will be
   created. Parameters such as the `secretRefName`, the `secretRefNamespace` and
   the `kvBackend.address` are mandatory.

   Additional `spec` parameters are available on the [Cluster Operator
   configuration](/docs/reference/cluster-operator/configuration) page.

   ```bash
   apiVersion: "storageos.com/v1"
   kind: StorageOSCluster
   metadata:
     name: storageos
     namespace: openshift-operators
   spec:
     # Ondat Pods are in kube-system by default
     secretRefName: "storageos-api" # Reference the Secret created in the previous step
     secretRefNamespace: "openshift-operators"  # Namespace of the Secret created in the previous step
     k8sDistro: "openshift"
     kvBackend:
       address: 'storageos-etcd-client.etcd:2379' # Example address, change for your etcd endpoint
     # address: '10.42.15.23:2379,10.42.12.22:2379,10.42.13.16:2379' # You can set ETCD server ips
     resources:
       requests:
         memory: "512Mi"
         cpu: 1
     # nodeSelectorTerms:
     #   - matchExpressions:
     #     - key: "node-role.kubernetes.io/worker" # Compute node label will vary according to your installation
     #       operator: In
     #       values:
     #       - "true"
   ```

    ![install-12](/images/openshift4/storageos-v2/120-create-cr-from-yaml.png)

1. Verify that the Ondat Cluster Resource enters a running state.

    ![install-13](/images/openshift4/storageos-v2/130-cr-created.png)

    > It can take up to a minute to report the Ondat Pods ready

1. Check the Ondat Pods in the `kube-system` project

    ![install-14](/images/openshift4/storageos-v2/140-storageos-pods.png)

    > A Status of 3/3 for the Daemonset Pods indicates that Ondat is
    > bootstrapped successfully.

1. License cluster

    > A newly installed Ondat cluster does not include a licence. A cluster
    > must be licensed within 24 hours of the installation. For more information,
    > check the [reference licence page]({{ ref . "docs/reference/licence.md" }}).

    You can apply a Free Developer licence following the [operations
    licensing]({{ ref . "docs/operations/licensing.md" }}) page, or purchase a
    licence contacting sales@storageos.com.
