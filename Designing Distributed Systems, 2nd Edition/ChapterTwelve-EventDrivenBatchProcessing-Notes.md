Notes from chapter Twelve - Event-Driven Batch Processing

# TL;DR
In chapter 11 we looked at work queue systems to accomplish batched processing operations. Chapter 12 expands on that by discussing how we link multiple work queues together to create an event driven, batched processing workflow.
A lot of the time these systems will follow patterns that involve connecting multiple work queues where each work queue accomplishes a very specific goal in the workflow as a whole. Such as having a data copier --> filtering system --> a data splitter and grouper --> compute sharder and load balancer --> result merger, style architecture
Pub/Sub architecture is important here. The publishing workflow sends messages / outputs to named queues. The subscriber workflow listens to those queues and picks up those messages or outputs for further processing.
Good for things like priority or retry queues, idempotent workers, exponential backoff, etc.

# Outline
## Core
Batch processesing through chaining together multiple work queues.
The completion and output of one work queue feeds the next. 
Makes multi-step processing with independent stages.

## Linking patterns
There are multiple types of behavior a work queue can complete before the data or process gets passed on to the next queue.
### Copier
Takes one stream and turns it into two different identical streams
### Filter
Define a specific criteria, drop all items that do not meet that criteria.
### Splitter
Routes items to two different streams based on a specific criteria.
### Shader
Evenly divide work into multiple queues (however many defined)
### Merger
Combine multiple sources into one shared queue.

## Infra
Pub / sub over shared file systems.
replication and partitions are still important here to provide durability and parallelism.

## Resiliency and performance
### Work stealing
for replicated processes. Idle workers at the same stage take items from the back of longer queues, a form of load balancing. 
### Crashes
hide then complete is used to not duplicate work but still get the item back in the queue
### Poison items
track attempts on items, if threshold is reached assume corruption and quarantine