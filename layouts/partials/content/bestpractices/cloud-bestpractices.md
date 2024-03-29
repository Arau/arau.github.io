## Ondat in Cloud Environments

Cloud environments give users the ability to quickly scale the number of nodes
in a cluster in response to their needs. Because of the ephemeral nature of the
cloud, Ondat recommends setting conservative downscaling policies.

For production clusters, it is recommended to use dedicated instance groups for
Stateful applications that allow the user to set different scaling policies and
define Ondat pools based on node selectors to collocate volumes.

Losing a few nodes at the same time could cause the loss of data even when
volume replicas are being used.
