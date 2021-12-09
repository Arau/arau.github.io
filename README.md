# Docs V2 

## Dependencies

- [Dapper](https://github.com/rancher/dapper)
- Docker

## Configuration

The configuration files are in `./config`. For every version of the site a new
configuration file can be added in the format of `vX.X.X.toml` or
`vX.X.X.yaml`.

## How to run a local server

> The base image defined in the `Dockerfile.dapper` is pulled from a private
> repository. You can build your own image from `Dockerfile.build`.

To run the site locally execute:

```bash
make serve
```

> Check http://localhost:1313
> The site bounds to 0.0.0.0, so you can access the site from outside your
> computer

If you want to change specific parameters of the "hugo server" command you can
pass parameters as follows.

```bash
# Serve from a different port
make port=8888 serve

# or 

make conf=./config/v2.0.0.toml baseurl="http://mymachine.storageos.net/v2" serve
# access to http://mymachine.storageos.net:1313/v2 in your browser
```

> To serve from a different port, you also need to edit the
> `Dockerfile.dapper` to set the Container Engine port binding correctly.

> The default config file to serve is set at the top of the Makefile

## Structure of the Documentation

The main directories are:
  - config: configuration files for each site
  - content
    * content/v1: documentation content for the V1 site
    * content/v2: documentation content for the V2 site
    * content/any_new_version_aka_v2.1
  - layouts
    * shortcodes: snippets of code that render sections of output pages
    * partials: partial templates, they can include parts to be rendered, or
      parts of content.
  - sites/stable/public: HTML output
  - static: assets to be served from the / of the website
  - themes: Code that defines the website structure, skins or even behaviour

## Using Hugo

The setup above is build to simplify the developer environment. However using
Dapper adds layers of abstraction and complexity that might not be of
everyone's taste. You can use the basic tool, Hugo, to run the docs locally
following this section.

1.  Go to the [Hugo releases](https://github.com/gohugoio/hugo/releases) page.
2.  In the most recent release, scroll down until you find a list of **Extended** versions.
3.  Download the latest extended version (`hugo_extended_0.68.3_(...)-64bit.tar.gz`).
4.  Untar and place the binary in your path.

You can use "hugo" to build and run the documentation.

```bash
hugo server --config=./config/v2.4.toml --debug --verbose --baseURL http://localhost
```

## Release docs to production

### Requirements
To release documentation to production, it is needed to have hugo installed in
the machine that triggers the release. Using dapper for the release adds
unnecessary complexity and risk.

- Hugo (install following the previous section "Using Hugo")
- Git push access to the production repository

### How-To

```bash
./build/trigger-release.sh -m "Commit message for the release"
# Follow the script instructions to git push to production
```

### Details and protocol

There are 3 scripts in the `./build` directory. The `trigger_release.sh` uses
the other two to perform different actions.

- trigger_release.sh: Wrapper that calls the following scripts to perform a
  release.
- \_generate-site-output.sh: Builds the docs into a temporary dir.
- \_release-docs.sh: Handles the workflow using git to publish the site output
  to production.

> The \_release-docs.sh is used with the `-d` option or dryrun. That prevents
> the script from pushing the changes to production. It prepares the site and
> the repository and leaves to the user the last step. The `git push origin
> master`. The script indicates the steps on its output.

## How to add a new version of Ondat

## Minor versions

1. Edit the `config/$MINOR_VERSION`
    - Amend the `[params]` section that reflect the Ondat components
      versions (latest_node_version, latest_operator_version, etc)
1. Update the ./static/sh/deploy-storageos-cluster.sh script with the new CLI,
   Operator and Ondat versions.

### Major versions
The docs generate a new site for every Ondat major release. This section
explains how to add a new version in the release menu, and make the default
site, show the latest documentation.

The following instructions will use an example as the latest current release is
v2.1 and we want to create the site for v2.2.

1. Copy the current latest content dir to the next version

    ```bash
    OLD_RELEASE=v2.3
    NEW_RELEASE=v2.4
    cp -r content/$OLD_RELEASE content/$NEW_RELEASE
    ```
1. Remove aliases from the old content files
    The latest site should have all the redirects, any older release shouldn't.
    There are a few exceptions with 1.x.

    In the metadata area of the document, there is a section called aliases.
    Remove the section.

    ```bash
    # Check how many aliases are in the $OLD_RELEASE
    grep -R -c  "aliases" content/$OLD_RELEASE/ | wc -l
    105

    cd build
    ./remove-aliases.sh $OLD_RELEASE
    cd ..

    # Check if there are any alises in the $OLD_RELEASE
    grep -R -c  "aliases" content/$OLD_RELEASE/ | wc -l
    0
    ```

    The script executed runs the following procedure:
    Edit every file and remove the section, for instance for the first file: best-practices.md
    ```
    ---
    linkTitle: Best Practices
    title: Ondat Best Practices
    weight: 450
    aliases:                                      <-- REMOVE THIS LINE
      - /docs/platforms/kubernetes/bestpractices/ <-- REMOVE THIS LINE
      - /docs/platforms/aws-eks/bestpractices     <-- REMOVE THIS LINE
      - /docs/platforms/azure-aks/bestpractices   <-- REMOVE THIS LINE
      - /docs/platforms/dockeree/bestpractices    <-- REMOVE THIS LINE
      - /docs/platforms/kubernetes/bestpractices  <-- REMOVE THIS LINE
      - /docs/platforms/openshift/bestpractices   <-- REMOVE THIS LINE
      - /docs/platforms/rancher/bestpractices     <-- REMOVE THIS LINE
    ---
    ```

1. Create a new config file for the release

    ```bash
    cp config/$OLD_RELEASE config/$NEW_RELEASE
    ```

1. Add release link in all config files
    In every config file, there is a reference for the "releases" menu in the
    site, hence all config files need to add the new release section.

    At the end of the file, you will find the section `params.versions`.
      - You have to add the new version in all files.
      - Amend the current latest to its version (/v2.3)
      - Amend the latest version to serve from root (/)

    ```bash
    $ vi config/*

    [[params.versions]]
        version = "v1.x"
        url = '/v1.x'
    [[params.versions]]
        version = "v2.0"
        url = '/v2.0'
    [[params.versions]]
        version = "v2.1"
        url = '/v2.1'
    [[params.versions]]
        version = "v2.2"
        url = '/v2.2'
    [[params.versions]] 
        version = "v2.3"
        url = '/v2.3'   <-------- It was / before, change it to /v2.3
    [[params.versions]] <-------- New version section
        version = "v2.4"
        url = '/'       <-------- It is the main site now (default)
    ```

    > You might see the siteURL param at the beginning of the file. That param
    > is set in the build script, so you don't have to change it.

1. Edit the `config/$NEW_RELEASE`
    - Update the publishdir and contentdir
    - Amend the `[params]` section that reflect the Ondat components
      versions (latest_node_version, latest_operator_version, etc)

1. Update scripts that don't parametrise the release version

    In `static/sh` there are scripts that users can curl to install Ondat.
    Make sure that any reference to the version is updated there too.

1. Update the Jenkinsfile, env var `ROOT_VERSION`

1. Update Makefile and `build/trigger-release.sh` with the latest default
   version

## Misc

The theme use is based on https://github.com/google/docsy.git even though is
treated as part of the repository instead of a submodule. 
