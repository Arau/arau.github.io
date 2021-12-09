---
title: Licensing
---

A newly installed Ondat cluster does not include a licence. A cluster can
run unlicensed for 24 hours. After that, new operations such as volume
provisioning or adding nodes are not permitted. Normal functioning of the
cluster can be unlocked by applying for a Free Personal licence.

## Obtaining a Personal licence via the GUI


You will need access to the Ondat GUI on port 5705 of any of your nodes.
For convenience, it is often easiest to port forward the service using the
following kubectl incantation (this will block, so a second terminal window may
be advisable):

  ```bash
  $ kubectl port-forward -n kube-system svc/storageos 5705
  ```

As an alternative, an Ingress controller may be preferred.

## Obtaining a Personal licence

To get a personal license please email: [getstarted@storageos.com](mailto:getstarted@storageos.com)

## Applying a previously obtained licence via the GUI

Commercial licences are delivered through contact with the Ondat team.
To apply such keys, via the web GUI, visit the `licence` section of the GUI
and click on the tab "Upgrade", for the specific licence level you purchased.
Then paste the licence key and click on "UPLOAD KEY TO CLUSTER". Note that you
can also view your cluster ID on the same page.

![Apply Licence Key](/images/docs/operations/licensing/apply-licence-key.png)

## Applying a licence via the CLI

Before getting a licence, you need to know the ID of your Ondat cluster.

This CLI command can print the cluster ID:

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

Given the Cluster ID, the Ondat team can generate a licence. Once, given
the key, you can apply the licence by using the following command.

```bash
$ echo PASTE-THE-LICENCE-KEY-HERE | storageos apply licence --from-stdin
```

Read the [licence CLI command reference]({{< ref
"docs/reference/cli/apply.md" >}}) for further information.

## Obtaining an Enterprise licence

Please contact [sales@storageos.com](mailto:sales@storageos.com) to discuss
pricing for commercial licences.
