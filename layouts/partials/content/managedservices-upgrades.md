{{ $platform := .Get "platform" }}
## Kubernetes Upgrades on Managed Services

Managed services that support in place upgrades are fully supported. However,
upgrading Kubernetes using green/blue deployments **is not supported**. This is
because nodes are replaced rather than being upgraded. Any data stored on the
nodes is lost when new nodes replace the previous ones.
