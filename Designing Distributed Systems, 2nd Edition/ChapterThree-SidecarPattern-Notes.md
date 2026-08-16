# Notes from Chapter Three - Sidecar Pattern

## TL;DR
Chapters 3-5 discuss distributed computing architecture patterns for single node infrastructure. More specifically, chapter 3 discusses the sidecar pattern. In the sidecar pattern two containers share a single machine, network, and file directory. One of the pods is the main application, which is the actual workload. Then there is a sidecar, a separate container which supplements the main workload in some way. Common use cases are modernization of legacy applications without touching old source code, utility functionalities, etc.

## Outline
### Core
Workload container + supplemental sidecar container
Co-scheduled
Shares network, directory, and other resources
Sidecar is built to argument the workload

### Use Cases
#### Adapting legacy workloads
HTTP only services can be difficult to incorporate HTTPS. nginx sidecar can fix this by having the workload proxy via http to the localhost, then the sidecar handles external https
Dynamic configurations such as a sidecar watching an API for a configuration change or modifications to a shared file.

#### Reusable utilities (helpful in enterprises)
SWE team has a standardized workload for debugging internal enterprise applications. That can be a sidecar and attached to different workloads. 

#### PaaS style configs
The main workload can run a webapp and auto-load the sidecar. Then the sidecar handles receiving the Github actions workflow.

#### misc
Document sidecars in their dockerfile, have them be well commented, and make sure to comment things like ports or environment variables.
Parameterize
Think about building a sidecar like engineering a well designed API. Many of the best practices are applicable. 