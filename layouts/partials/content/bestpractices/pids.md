## Setting a Kubernetes PID limit

Ondat recommends that a PID cgroup limit of 32768 be set. Ondat is a
multi-threaded application and while most Kubernetes distributions set the PID
cgroup limit to 32768, some environments can set a limit as low as 1024. The
Ondat init container will print a log message warning if the PID cgroup
limit is too low. See our [prerequisites](/docs/prerequisites/pidlimits) for
more information.
