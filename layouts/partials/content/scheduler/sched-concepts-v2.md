## Storageos Kubernetes Scheduler

Ondat achieves Pod locality by implementing a Kubernetes scheduler
extender. The Kubernetes standard scheduler interacts with the Ondat
scheduler when placement decisions need to be made.

The Kubernetes standard scheduler selects a set of nodes for a placement
decision based on nodeSelectors, affinity rules, etc. This list of nodes is
sent to the Ondat scheduler which sends back the target node where the Pod
shall be placed.

The Ondat scheduler logic is provided by a Pod in the Namespace where
Ondat Pods are running.

## Scheduling process

When a Pod needs to be scheduled, the scheduler collects information
about all available nodes and the requirements of the Pod. The collected
data is then passed through the Filter phase, during which the scheduler predicates
are applied to the node data to decide if the given nodes are compatible
with the Pod requirements. The result of the filter consists of a list of nodes
that are compatible for the given Pod and a list of nodes that aren't
compatible.

The list of compatible nodes is then passed to the Prioritize phase, in which
the nodes are scored based on attributes such as the state. The result of the
Prioritize phase is a list of nodes with their respective scores. The more
favorable nodes get higher scores than less favorable nodes. The list is then
used by the scheduler to decide the final node to schedule the Pod on.

Once a node has been selected, the third phase, Bind, handles the binding
of the Pod to the Kubernetes apiserver. Once bound, the kubelet on the node
provisions the Pod.

The Ondat scheduler implement Filter and Prioritization phases and leaves
binding to the default Kubernetes scheduler.

```bash
    Available         +------------------+                     +------------------+
  NodeList & Pod      |                  |  Filtered NodeList  |                  |    Scored
   Information        |                  |  & Pod Information  |                  |   NodeList
+-------------------->+      Filter      +-------------------->+    Prioritize    |--------------->
                      |   (Predicates)   |                     |   (Priorities)   |
                      |                  |                     |                  |
                      +------------------+                     +------------------+

```


## Scheduling Rules

The Ondat scheduler filters nodes ensuring that the remaining subset
fulfill the following prerequisites:

- The node is running Ondat
- The node is healthy
