---
title: Licensing
---

A newly installed Ondat cluster does not include a licence. A cluster can
run unlicensed for 24 hours. After that, new operations such as volume
provisioning or adding nodes are not permitted. Normal functioning of the
cluster can be unlocked by applying for a Free Personal licence.

## Accessing Ondat GUI

You will need access to the Ondat GUI on port 5705 of any of your nodes.

For convenience, it is often easiest to port forward the service using the
following kubectl incantation (this will block, so a second terminal window may
be advisable):

  ```bash
  $ kubectl port-forward -n kube-system svc/storageos 5705
  ```
As an alternative, an Ingress controller may be preferred.

One can then access the Ondat GUI from
[http://localhost:5705](http://localhost:5705).

**N.B.** *For the rest of this tutorial we assume you are accessing the
Ondat GUI as described above. You can substitute `http://localhost` for
`http://your-cluster-domain-name-or-ip` if necessary.*

## Obtaining a Personal licence

To get a personal license, email [getstarted@storageos.com](mailto:getstarted@storageos.com)

## Obtaining a Commercial licence

Commercial licences are delivered through contact with the Ondat team
([info@storageos.com](mailto:info@storageos.com)).

You will need to provide your Ondat cluster ID, which can be found on the
licence page of the web UI
([http://localhost:5705/#/licence](http://localhost:5705/#/licence)), under
*"Licence details"*.

Alternately you can use this CLI command to print the cluster ID:

```bash
$ storageos get cluster
ID:               704dd165-9580-4da4-a554-0acb96d328cb
Licence:
  expiration:     2021-03-25T13:48:46Z (1 year from now)
  capacity:       5.0 TiB
  kind:           professional
  customer name:  storageos
Created at:       2020-03-25T13:48:33Z (1 hour ago)
Updated at:       2020-03-25T13:48:46Z (1 hour ago)
```

The licence obtained from the Ondat team will come in the following format:

``` text
clusterCapacityGiB: 5120
clusterID: 164237eb-f88a-4bb8-a7cf-a23d468e07c0
customerName: storageos
expiresAt: "2021-11-15T14:00:00Z"
features:
- nfs
kind: project

------------- LICENCE SIGNATURE -------------
KyjNleTcdmieZVLmZ/rg0SzdAM7I/CH0j22FIFJJSJaeB71OvQrTMtHGyL5TSFNMrEGbyh1HQlDgZb5A
V1HyjBlS3LjoB/MoagulTxIlZh/R8eRXCOQ46qNZ8Yb7+dHLdCVXBnRqZT11hLqZsMqIeO1y9f5dw65H
kvl6vWW7YIS9r655S25jMMU7brrGDQVdjvU7tSA74BrnzDFHu7/poopIuFqcxZc/NLrKp/akkvyZI5Ex
1wH7D4onjVG2pgi30Kia+mjbI1B9pxQyRppQQ4hNXy4qBUUNMFh0menh0wHdQoM1VLU4Il22PrkeICV0
NaalLsK/96bJov6tpbg96g==
```

**N.B.** *All of this string is necessary to activate a licence - not just the
signature section*

## Applying a licence via the web UI

To apply a licence via the web UI, visit the *"Licence"* section of the UI
([http://localhost:5705/#/licence](http://localhost:5705/#/licence)) and click
on the *"Upgrade"* button, for the specific licence level you purchased. Then
paste the licence key into the pop-up and click on **"UPGRADE"**.

>**It is crucial to paste ALL the licence text into the pop-up and not just the signature**

![Apply Licence Key](/images/docs/operations/licensing/apply-licence-key.png)

**N.B.** Warning: Extra whitespace in the licence string will stop
the licence from applying. You must take extra care to ensure that the string is
pasted in exactly the same state in which it was received from the Ondat
team.

## Applying a licence via the CLI

The following command will apply the licence key stored in
`/path/to/storageos-licence.dat`:


```bash
$ storageos apply licence --from-file /path/to/storageos-licence.dat
```

Read the [licence CLI command reference]({{< ref
"docs/reference/cli/apply.md" >}}) for further information.

## Obtaining an enterprise licence

To discuss pricing for enterprise licences, contact [sales@storageos.com](mailto:sales@storageos.com) t.
