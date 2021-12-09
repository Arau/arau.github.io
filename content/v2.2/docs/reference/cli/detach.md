---
title: Detach Volume
---

```bash
$ storageos detach --help
Detach a volume from its current location

Usage:
  storageos detach [flags]

Examples:

$ storageos detach volume --namespace my-namespace-name my-volume


Flags:
      --cas string   make changes to a resource conditional upon matching a provided version
  -h, --help         help for detach

Global Flags:
      --endpoints stringArray   set the list of endpoints which are used when connecting to the Ondat API (default [http://localhost:5705])
  -n, --namespace string        specifies the namespace to operate within for commands that require one (default "default")
  -o, --output string           specifies the output format (one of [json yaml text]) (default "text")
      --password string         set the Ondat account password to authenticate with (default "storageos")
      --timeout duration        set the timeout duration to use for execution of the command (default 5s)
      --use-ids                 specify existing Ondat resources by their unique identifiers instead of by their names
      --username string         set the Ondat account username to authenticate as (default "storageos")
```
