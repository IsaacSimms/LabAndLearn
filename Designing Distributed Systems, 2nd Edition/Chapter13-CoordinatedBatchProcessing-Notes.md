# Notes from Chapter 13 - Coordinated Batch Processing

## TL;DR
Split work --> perform operation --> bring back together is a common pattern.

## Outline
### core 
Join: waits until every piece finishes then brings together.
Reduce: merge partial results step by step

### Join
Holds all until inter merger
guarantees complete data set and security
Higher latency and reduces parallelism

### Reduce
Merges partial data sets throughout the workflow
can be repleated throughout the workflow. Improves latency and paralleleism at the cost of security