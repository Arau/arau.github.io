---
title: Apply licence
---

```bash
$ storageos apply licence --help

Usage:
  storageos apply licence [flags]

Examples:

$ storageos apply licence --from-file <path-to-licence-file>

$ echo "<licence file contents>" | storageos apply licence --from-stdin


Flags:
      --from-file string   reads a Ondat product licence from a specified file path
      --from-stdin         reads a Ondat product licence from the standard input
  -h, --help               help for licence

Global Flags:
      --endpoints stringArray   set the list of endpoints which are used when connecting to the Ondat API (default [http://localhost:5705])
  -n, --namespace string        specifies the namespace to operate within for commands that require one (default "default")
  -o, --output string           specifies the output format (one of [json yaml text]) (default "text")
      --password string         set the Ondat account password to authenticate with (default "storageos")
      --timeout duration        set the timeout duration to use for execution of the command (default 5s)
      --use-ids                 specify existing Ondat resources by their unique identifiers instead of by their names
      --username string         set the Ondat account username to authenticate as (default "storageos")
```
