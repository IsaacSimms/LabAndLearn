# Notes from Chapter Eleven - Work Queue Systems

## TL;DR
A work queue system is a type of batch processing pattern. It is arguably the most common batch processing architecture.
Batch processing is a workload where each item can be handled on its own with no interaction between items.
The system proccesses those items in on set over a predefined period of time.
Workers and compute are scaled in order to meet the demands of that batch.
A work queue is exactly as it sounds. That batched workload is organized into a queue and processed as such. 

## Outline
### Core
Independent items are batched into a single workload and processed as one unit.
The infra processing the batch is scaled to meet demand.
Scaling up and down occurs to balance cost and latency.

### Reusability and modularity
These systems should be designed to work with a variety of different workloads. 
Generic queue manager is the core of the system. 
Application specific source containers and worker containers are brought to the queue manager for processing.
The queue manager infra is shared.

### Scaling
Limit max concurrent jobs to control spend.
Track inter-arrival time of new items and calc average processing latency to determine if scaling needs to change. 
Scale accordingly. processing latency < inter-arrival time.
Can have specialized workers within the architecture. PArticularly helpful for batch workloads that are intense and/or happen frequently. 