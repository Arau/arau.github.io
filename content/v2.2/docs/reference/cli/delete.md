---
title: Delete
---

```bash
$ storageos delete -h

Delete resources in the cluster

Usage:
  storageos delete [command]

Available Commands:
  volume      Delete a volume

Flags:
  -h, --help   help for delete

Global Flags:
      --endpoints stringArray   set the list of endpoints which are used when connecting to the Ondat API (default [http://localhost:5705])
  -n, --namespace string        specifies the namespace to operate within for commands that require one (default "default")
  -o, --output string           specifies the output format (one of [json yaml text]) (default "text")
      --password string         set the Ondat account password to authenticate with (default "storageos")
      --timeout duration        set the timeout duration to use for execution of the command (default 5s)
      --use-ids                 specify existing Ondat resources by their unique identifiers instead of by their names
      --username string         set the Ondat account username to authenticate as (default "storageos")

Use "storageos delete [command] --help" for more information about a command.
```

## delete volume

```bash
$ storageos delete volume --help
Delete a volume

Usage:
  storageos delete volume [volume name] [flags]

Examples:

$ storageos delete volume my-test-volume my-unneeded-volume

$ storagoes delete volume --namespace my-namespace my-old-volume


Flags:
      --async        perform the operation asynchronously, using the configured timeout duration
      --cas string   make changes to a resource conditional upon matching a provided version
  -h, --help         help for volume

Global Flags:
      --endpoints stringArray   set the list of endpoints which are used when connecting to the Ondat API (default [http://localhost:5705])
  -n, --namespace string        specifies the namespace to operate within for commands that require one (default "default")
  -o, --output string           specifies the output format (one of [json yaml text]) (default "text")
      --password string         set the Ondat account password to authenticate with (default "storageos")
      --timeout duration        set the timeout duration to use for execution of the command (default 5s)
      --use-ids                 specify existing Ondat resources by their unique identifiers instead of by their names
      --username string         set the Ondat account username to authenticate as (default "storageos")
```
