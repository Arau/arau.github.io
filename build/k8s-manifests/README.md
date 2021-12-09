# Staging infrastructure definition

This directory holds the Kubernetes manifests needed to run the docs. The aim
is to use them in a staging site as part of a Pull Request review.

The yamls ought to be templated to have the capacity to reuse them for all
different branches of the docs.

## Kubernetes objects

For every branch of the docs, it is needed to deploy a webserver with the
compiled version of the HEAD of the branch, i.e a Deployment; a Service
referencing that Pod and an Ingress to access the website.

To achieve that we are using `kustomize`

## Templated resources

For the CI server to be able to create those resources easily, we are using
`kustomize`. That gives the capacity to have tidy templated Kubernetes
resources.

The `base` directory holds the base yamls needed. Then there is one environment
example called `branch-example` that holds the specifics to create the
resources from base but with the specifics for that environment.

### How-To generate yamls

```
$ kubectl kustomize branch-example
```

### How-To apply the manifests to your k8s cluster

> First, create the namespace. We don't want to template the namespace, but to
> put all resources in one.

```
$ kubectl apply -f ./bases/00-docs-ns.yaml
$ kubectl apply --kustomize branch-example
```

## How-To create a new environment

> It is expected for the CI pipeline to execute the following instructions.

```
NEW_BRANCH=new-branch
cp -r branch-example $NEW_BRANCH
cd $NEW_BRANCH

# For Mac
find . -type f -exec sed -i.bak "s/branch-example/$NEW_BRANCH/g" {} \;
find . -type f -name '*.bak' -exec rm -f {} \;

# For Linux
find . -type f -exec sed -i "s/branch-example/$NEW_BRANCH/g" {} \;

cd ..
kubectl apply -f ./bases/00-docs-ns.yaml
kubectl apply --kustomize $NEW_BRANCH
```

## How-To remove an environment

```
NEW_BRANCH=new-branch
kubectl delete --kustomize $NEW_BRANCH
```
