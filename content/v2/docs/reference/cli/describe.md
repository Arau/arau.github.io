---
title: Describe
---


```bash
$ storageos describe --help
Fetch extended details for resources

Usage:
  storageos describe [command]

Available Commands:
  node        Retrieve detailed information for nodes in the cluster
  volume      Show detailed information for volumes

Flags:
  -h, --help   help for describe

Global Flags:
      --endpoints stringArray   set the list of endpoints which are used when connecting to the Ondat API (default [http://localhost:5705])
  -n, --namespace string        specifies the namespace to operate within for commands that require one (default "default")
  -o, --output string           specifies the output format (one of [json yaml text]) (default "text")
      --password string         set the Ondat account password to authenticate with (default "storageos")
      --timeout duration        set the timeout duration to use for execution of the command (default 5s)
      --use-ids                 specify existing Ondat resources by their unique identifiers instead of by their names
      --username string         set the Ondat account username to authenticate as (default "storageos")

Use "storageos describe [command] --help" for more information about a command.
```

## describe node

```bash
$ storageos describe node --help
Retrieve detailed information for nodes in the cluster

Usage:
  storageos describe node [node names...] [flags]

Aliases:
  node, nodes

Examples:

$ storageos describe node my-node-name


Flags:
  -h, --help                   help for node
  -l, --selector stringArray   filter returned results by a set of comma-separated label selectors

Global Flags:
      --endpoints stringArray   set the list of endpoints which are used when connecting to the Ondat API (default [http://localhost:5705])
  -n, --namespace string        specifies the namespace to operate within for commands that require one (default "default")
  -o, --output string           specifies the output format (one of [json yaml text]) (default "text")
      --password string         set the Ondat account password to authenticate with (default "storageos")
      --timeout duration        set the timeout duration to use for execution of the command (default 5s)
      --use-ids                 specify existing Ondat resources by their unique identifiers instead of by their names
      --username string         set the Ondat account username to authenticate as (default "storageos")
```

## describe volume

```bash
$ storageos describe volume --help
Show detailed information for volumes

Usage:
  storageos describe volume [volume names...] [flags]

Aliases:
  volume, volumes

Examples:

$ storageos describe volumes

$ storageos describe volume --namespace my-namespace-name my-volume-name


Flags:
  -h, --help                   help for volume
  -l, --selector stringArray   filter returned results by a set of comma-separated label selectors

Global Flags:
      --endpoints stringArray   set the list of endpoints which are used when connecting to the Ondat API (default [http://localhost:5705])
  -n, --namespace string        specifies the namespace to operate within for commands that require one (default "default")
  -o, --output string           specifies the output format (one of [json yaml text]) (default "text")
      --password string         set the Ondat account password to authenticate with (default "storageos")
      --timeout duration        set the timeout duration to use for execution of the command (default 5s)
      --use-ids                 specify existing Ondat resources by their unique identifiers instead of by their names
      --username string         set the Ondat account username to authenticate as (default "storageos")
```
