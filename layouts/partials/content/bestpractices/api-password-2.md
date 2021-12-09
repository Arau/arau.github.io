## Ondat API username/password

The API grants full access to Ondat functionality, therefore we recommend
that the default administrative password of 'storageos' is reset to something
unique and strong.

You can change the default parameters by encoding the `username` and
`password` values (in base64) into the `storageos-api` secret.

To generate a unique password, a technique such as the following, which
generates a pseudo-random 24 character string, may be used:

```bash
# Generate strong password
PASSWORD=$(cat -e /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*()_+~' | fold -w 24 | head -n 1)

# Convert password to base64 representation for embedding in a K8S secret
BASE64PASSWORD=$(echo -n $PASSWORD | base64)
```

Note that the Kubernetes secret containing a strong password *must* be created
before bootstrapping the cluster. Multiple installation procedures use this
Secret to create a Ondat account when the cluster first starts.
