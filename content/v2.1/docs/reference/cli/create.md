---
title: Create
---


```bash
$ storageos create --help
Create new resources

Usage:
  storageos create [command]

Available Commands:
  user        Create a new user account
  volume      Provision a new volume

Flags:
  -h, --help   help for create

Global Flags:
      --endpoints stringArray   set the list of endpoints which are used when connecting to the Ondat API (default [http://localhost:5705])
  -n, --namespace string        specifies the namespace to operate within for commands that require one (default "default")
  -o, --output string           specifies the output format (one of [json yaml text]) (default "text")
      --password string         set the Ondat account password to authenticate with (default "storageos")
      --timeout duration        set the timeout duration to use for execution of the command (default 5s)
      --use-ids                 specify existing Ondat resources by their unique identifiers instead of by their names
      --username string         set the Ondat account username to authenticate as (default "storageos")

Use "storageos create [command] --help" for more information about a command.
```

## create volume
```bash
$ storageos create volume --help
Provision a new volume

Usage:
  storageos create volume [flags]

Examples:

$ storageos create volume --description "This volume contains the data for my app" --fs-type "ext4" --labels env=prod,rack=db-1 --size 10GiB --namespace my-namespace-name my-app

$ storageos create volume --replicas 1 --namespace my-namespace-name my-replicated-app


Flags:
      --async                       perform the operation asynchronously, using the configured timeout duration
      --cache                       caches volume data (default true)
      --compress                    compress data stored by the volume at rest and during transit (default true)
  -d, --description string          a human-friendly description to give the volume
  -f, --fs-type string              the filesystem to format the new volume with once provisioned (default "ext4")
  -h, --help                        help for volume
  -l, --labels strings              an optional set of labels to assign to the new volume, provided as a comma-separated list of key=value pairs
  -r, --replicas uint               the number of replicated copies of the volume to maintain
  -s, --size string                 the capacity to provision the volume with (default "5GiB")
      --throttle                    deprioritises the volume's traffic by reducing the rate of disk I/O

Global Flags:
      --endpoints stringArray   set the list of endpoints which are used when connecting to the Ondat API (default [http://localhost:5705])
  -n, --namespace string        specifies the namespace to operate within for commands that require one (default "default")
  -o, --output string           specifies the output format (one of [json yaml text]) (default "text")
      --password string         set the Ondat account password to authenticate with (default "storageos")
      --timeout duration        set the timeout duration to use for execution of the command (default 5s)
      --use-ids                 specify existing Ondat resources by their unique identifiers instead of by their names
      --username string         set the Ondat account username to authenticate as (default "storageos")
```

## create user
```bash
$ storageos create user --help
Create a new user account

Usage:
  storageos create user [flags]

Examples:

$ storageos create user --with-username=alice --with-admin=true


Flags:
  -h, --help                      help for user
      --with-admin                control whether the user is given administrative priviledges
      --with-groups stringArray   the list of policy groups to assign to the user
      --with-password string      the password to assign to the user. If not specified, this will be prompted for.
      --with-username string      the username to assign

Global Flags:
      --endpoints stringArray   set the list of endpoints which are used when connecting to the Ondat API (default [http://localhost:5705])
  -n, --namespace string        specifies the namespace to operate within for commands that require one (default "default")
  -o, --output string           specifies the output format (one of [json yaml text]) (default "text")
      --password string         set the Ondat account password to authenticate with (default "storageos")
      --timeout duration        set the timeout duration to use for execution of the command (default 5s)
      --use-ids                 specify existing Ondat resources by their unique identifiers instead of by their names
      --username string         set the Ondat account username to authenticate as (default "storageos")
```
