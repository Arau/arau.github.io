## 2. Create a Secret

Before deploying a Ondat cluster, create a Secret defining the Ondat
API Username and Password in base64 encoding.

{{- if (eq (.Get "storageos_version") "2") }}
The API username and password are used to create the default Ondat admin
account which can be used with the Ondat CLI and to login to the Ondat
GUI. The CSI credentials are used to register the CSI accounts, so Kubernetes
and Ondat communicate over an authenticated API.

{{ partial "content/secret-v2.md" . }}

{{- else }}
The API username and password are used to create the default Ondat admin
account which can be used with the Ondat CLI and to login to the Ondat
GUI. The account defined in the secret is also used by Kubernetes to
authenticate against the Ondat API when installing with the native driver.

{{ partial "content/secret-v1.md" . }}

{{- end }}


This example contains a default password, for production installations, use a
unique, strong password.

> You can define a base64 value by `echo -n "mystring" | base64`.

> Make sure that the encoding of the credentials doesn't have special characters such as '\n'.
> The `echo -n` ensures that a trailing new line is not appended to the string.

> If you wish to change the default accounts details post-install please see [Managing
> Users](/docs/operations/users#altering-the-storageos-api-account)
