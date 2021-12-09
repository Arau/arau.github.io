---
title: Etcd
---

Ondat requires an etcd cluster in order to function.

For more information on why etcd is required please see our [etcd concepts]({{<
ref "docs/concepts/etcd.md">}}) page and for production recommendations for
etcd installations please see our [Etcd Operations]({{< ref
"docs/operations/external-etcd/_index.md" >}}) page.

> N.B. Ondat does not recommend using the Kubernetes etcd cluster for
> Ondat installations

## Using Etcd with Ondat

During installation of Ondat the `kvBackend` parameters of the Ondat
operator are used to specify the address of the etcd cluster. See the
[Ondat cluster operator
configuration](/docs/reference/cluster-operator/examples/) examples for more
information.
