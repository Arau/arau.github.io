---
title: Get
---


```bash
$ storageos get --help
Fetch basic details for resources

Usage:
  storageos get [command]

Available Commands:
  cluster     Fetch cluster-wide configuration details
  diagnostics Fetch a cluster diagnostic bundle
  namespace   Retrieve basic details of cluster namespaces
  node        Retrieve basic details of nodes in the cluster
  user        Fetch user details
  volume      Retrieve basic details of volumes

Flags:
  -h, --help   help for get

Global Flags:
      --endpoints stringArray   set the list of endpoints which are used when connecting to the Ondat API (default [http://localhost:5705])
  -n, --namespace string        specifies the namespace to operate within for commands that require one (default "default")
  -o, --output string           specifies the output format (one of [json yaml text]) (default "text")
      --password string         set the Ondat account password to authenticate with (default "storageos")
      --timeout duration        set the timeout duration to use for execution of the command (default 5s)
      --use-ids                 specify existing Ondat resources by their unique identifiers instead of by their names
      --username string         set the Ondat account username to authenticate as (default "storageos")

Use "storageos get [command] --help" for more information about a command.
```

## get cluster

```bash
$ storageos get cluster  --help
Fetch cluster-wide configuration details

Usage:
  storageos get cluster [flags]

Examples:

$ storageos get cluster


Flags:
  -h, --help   help for cluster
```

## get diagnostics

```bash
$ storageos get diagnostics  --help
Fetch a cluster diagnostic bundle

Usage:
  storageos get diagnostics [flags]

Examples:

$ storageos get diagnostics

$ storageos get diagnostics --output-file ~/my-diagnostics


Flags:
  -h, --help                 help for diagnostics
      --output-file string   writes the generated diagnostic bundle to a specified file path
```

## get namespace

```bash
$ storageos get namespace  -h
Retrieve basic details of cluster namespaces

Usage:
  storageos get namespace [namespace names...] [flags]

Aliases:
  namespace, namespaces

Examples:

$ storageos get namespaces

$ storageos get namespace my-namespace-name


Flags:
  -h, --help                   help for namespace
  -l, --selector stringArray   filter returned results by a set of comma-separated label selectors
```

## get node

```bash
$ storageos get node  -h
Retrieve basic details of nodes in the cluster

Usage:
  storageos get node [node names...] [flags]

Aliases:
  node, nodes

Examples:

$ storageos get node my-node-name


Flags:
  -h, --help                   help for node
  -l, --selector stringArray   filter returned results by a set of comma-separated label selectors
```

## get user

```bash
$ storageos get user -h
Fetch user details

Usage:
  storageos get user [user names...] [flags]

Aliases:
  user, users

Examples:

$ storageos get user my-username
$ storageos get user my-username-1 my-username-2
$ storageos get user --use-ids my-userid
$ storageos get user --use-ids my-userid-1 my-userid-2


Flags:
  -h, --help   help for user
```

## get volume

```bash
$ storageos get volume -h
Retrieve basic details of volumes

Usage:
  storageos get volume [volume names...] [flags]

Aliases:
  volume, volumes

Examples:

$ storageos get volumes --all-namespaces

$ storageos get volume --namespace my-namespace-name my-volume-name


Flags:
      --all-namespaces         retrieves volumes from all accessible namespaces. This option overrides the namespace configuration
  -h, --help                   help for volume
  -l, --selector stringArray   filter returned results by a set of comma-separated label selectors
```
