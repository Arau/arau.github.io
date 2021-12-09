---
title: Licensing
---

A newly installed Ondat cluster does not include a licence. A cluster can
run unlicensed for 24 hours. After that, new operations such as volume
provisioning or adding nodes are not permitted. Normal functioning of the
cluster can be unlocked by applying for a Free Developer licence.

## Obtaining a Developer licence via the GUI

You can obtain and apply a free Developer licence in the Ondat web GUI by
creating or logging in with a Ondat account on the Ondat portal via the
licence page of the Ondat web GUI:

> You can access the [GUI]({{< ref "docs/reference/gui.md" >}}) on any node
> running the Ondat Daemonset on the port 5705. Whether using an Ingress
> route or port-forwarding.

![Licence Login](/images/docs/operations/licensing/licence-login.png)

Wait a few seconds for the licence generation process to complete, at which
point your licence will be visible.

![Developer Licence](/images/docs/gui-v2/license.png)

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
