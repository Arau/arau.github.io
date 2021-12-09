---
title: Command line interface
linkTitle: CLI
---


The `storageos` command line interface (CLI) is used to manage cluster-wide
configuration.

## Installation

```bash
# linux/amd64
curl -sSLo storageos https://github.com/storageos/go-cli/releases/download/{{< param latest_cli_version >}}/storageos_linux_amd64 && chmod +x storageos && sudo mv storageos /usr/local/bin/

# MacOS
curl -sSLo storageos https://github.com/storageos/go-cli/releases/download/{{< param latest_cli_version >}}/storageos_darwin_amd64 && chmod +x storageos && sudo mv storageos /usr/local/bin/
```

You will need to provide the correct credentials to connect to the API. The
default installation uses the `storageos-api` Secret to generate the first
admin user. By default, it creates a single user with username `storageos` and
password `storageos`:

```bash
export STORAGEOS_USERNAME=storageos
export STORAGEOS_PASSWORD=storageos
export STORAGEOS_ENDPOINTS=10.1.5.249:5705
```

## Usage

```bash
$ storageos
Storage for Cloud Native Applications.

By using this product, you are agreeing to the terms of the the Ondat Ltd. End
User Subscription Agreement (EUSA) found at: https://storageos.com/legal/#eusa

To be notified about stable releases and latest features, sign up at https://my.storageos.com.

Usage:
  storageos [command]

Available Commands:
  apply       Make changes to existing resources
  attach      Attach a volume to a node
  create      Create new resources
  delete      Delete resources in the cluster
  describe    Fetch extended details for resources
  detach      Detach a volume from its current location
  get         Fetch basic details for resources
  help        Help about any command
  version     View version information for the Ondat CLI

Flags:
      --endpoints stringArray   set the list of endpoints which are used when connecting to the Ondat API (default [http://localhost:5705])
  -h, --help                    help for storageos
  -n, --namespace string        specifies the namespace to operate within for commands that require one (default "default")
  -o, --output string           specifies the output format (one of [json yaml text]) (default "text")
      --password string         set the Ondat account password to authenticate with (default "storageos")
      --timeout duration        set the timeout duration to use for execution of the command (default 5s)
      --use-ids                 specify existing Ondat resources by their unique identifiers instead of by their names
      --username string         set the Ondat account username to authenticate as (default "storageos")

Additional help topics:
  storageos env       View documentation for configuration settings which can be set in the environment
  storageos exitcodes View documentation for the exit codes used by the Ondat CLI
```

## Formatting CLI Output

Ondat CLI output can be formatted using the `--output` option. The strings
that are passed to `--output` are 'json', 'yaml' or 'text'.

## Cheatsheet

| Command       | Subcommand                                            | Description                                                      |
| ------------- | -------------------------------                       | ---------------------------------------------------------------- |
| `apply`       | `licence`                                             | Apply licence to cluster.                                        |
| `attach`      |                                                       | Attach Volume to a node.                                         |
| `create`      | `user, volume`                                        | Create resources such as users or volumes.                       |
| `delete`      | `volume`                                              | Delete resources.                                                |
| `describe`    | `node, volume`                                        | Show detailed view of resources.                                 |
| `detach`      | `volume`                                              | Detach volume from a node.                                       |
| `get`         | `cluster, diagnostics, namespace, node, user, volume` | List resources.                                                  |
| `help`        |                                                       | Help                                                             |
| `version`     |                                                       | Show CLI version.                                                |

[Source is available on Github](https://github.com/storageos/go-cli).
