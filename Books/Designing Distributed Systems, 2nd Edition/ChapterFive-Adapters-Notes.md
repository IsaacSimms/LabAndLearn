# Notes from Chapter Five - Adapter Pattern - notes

## TL;DR
Like what has been previously discussed with Sidecars and Ambassadors, adapters are a single-node pattern. They sit in the same pod as the workload and provide some sort of augment to the application container. In the case of adapters that augment revolves around the interface. The adapter will take the provided interface and seams from the workload as it stands and translate that into the interface that is expected by another service. It is common to have containers outside of the primary workload to provide some sort of service such as logging or health checks that require robust interaction with the workload itself. The adapter sits in the middle of those two pieces and makes sure that communication is successful and efficient.

## Outline
### Core
Workload plus adapter two separate containers in the same pod
Adapter translates the workloads existing interface to meet the conventions of a separate service
Enables one external service to perform an action such as logging or monitoring on many different applications

### Why
Common for systems to have a mix of languages and a mix of proprietary code, vendor's code, and open-source code. All with different conventions, styles, requirements, etc. Instead of trying to handle things like logging and health checks and logging all within each individual module, an adapter allows for uniformity, modularity, and conformity between all intities.
It makes dispurse and varied system safer and easier to maintain. 

### Monitoring and logging
A well built adapter will be able to intake a wide range of logs, normalize them, and then store them in a standardized location and format.
It is common for adapter to provide a predfined, standard set of monitoring metrics for each module to interface with. 
It is also common for the attached adapter to be what runs health checks on the workload. This allows for the addition of health checks and the modification of existing health checks without interfearing with the application.

### Summary and benefits
Applications can be updated without having to modify the logging/monitoring entity. and vice versa. This improves velocity.
Adapters are reusable accross many different workloads and modules within a system.
Lessons the need to interact with third party images such as open source or vendor software.
Improves container isolation and seperaton of responsibilities