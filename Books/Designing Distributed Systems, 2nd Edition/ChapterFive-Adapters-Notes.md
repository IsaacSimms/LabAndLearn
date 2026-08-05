# Notes from Chapter Five - Adapter Pattern - notes

## TL;DR
Like what has been previously discussed with Sidecars and Ambassadors, adapters are a single-node pattern. They sit in the same pod as the workload and proivde some sort of augment to the application container. In the case of adapters that augment revolvesa round the interface. The adapter will take the provided interface and seams from the workload as it stands and translate that into the interface that is expected by another service. It is common to have containers outisde of the prumary workload to provide some sort of service such as logging or health checks that require robust interaction with the workload itself. The adapter sits in the middle of those two pieces and makes sure that communication is successful and efficient.

## Outline
### Core
Workload plus adpater two seperate containers in the same pod
Adapter translates the workloads existing interface to meet the conventions of a seperate service
Enables one external service to perform an action such as logging or monitoring on many different applications

