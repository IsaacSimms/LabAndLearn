# Notes from Chapter Eight - Scatter/Gather pattern

## TL;DR
Scatter/gather is a form of replication system that focuses on scalability and efficiently in terms of time.
There is a root and leaf nodes. The root sends a request to all leafs all at the same time.
Each leaf is able to do a small amount of the total request. The root then gathers those pieces and combine them into a complete response.
Can be a relatively complicated system but the goal is to parallelize the work to reduce latency.

## Variants
### Root distribution
Each leaf is homogenous, meaning they all have the same data. They work in parallel purely for latency reduction.
### Leaf sharding
As previously discussed, the data is split accross the set of leaves. A request still goes to every leaf, but each leaf only returns with matches from its data set. Some leaves may not
have any matches at all.

## Number of leafs
The more leafs you have the more that you can parallelize, which, in theory should reduce latency. But that introduces complexity into the system and causes request overhead.
Beyond a certian point, depending on your system, more leafs stops being helpful. Overall latency is often determined by slowest leaf.

## Scaling and SLA 
One replica of a single leaf is very fragile, just like any other system really.
Prod systems will have a replica of each leaf with a load balancer that distributes across healthy replicas of each shard.