# Notes from Chapter Four - Ambassador Pattern - notes

## TL;DR
Like the sidecar pattern, the Ambassador pattern is a single node pattern. This means that both the application container and the abassador sit in the same pod. They share the same resources Abassador containers specialize in brokering all communication with the external world on behalf of the application and related architecture. The application container communicates with the ambassador over localhost specifically then the ambassador handes routing, sharding logic, etc. 

## Outline
### Core
App and abassador container in same pod
Ambassador is a traffic broker. A well built ambassador is reusable accross many different applications.
Application only knows localhost

### Value
clean seperation of concerns (important in enterprise. networking team can cleanly handle networking logic and SWEs can cleanly handle app logic. as an exmaple)
application logic is similar and easier to maintain
networking logic is higher quality

### Sharding
If you are going to shard some infrastructure ambassadors help centralize the complexity. instead of spreading networking logic across your database container and your api container, an ambassador can handle all of the external networking logic

### Request splitting
Let's say you are a/b testing an api change. An ambassador handles the routing, so you could split traffic at the ambassador container and have 90% go one way then the other 10% go the other.

## Summary
Ambassadors are a container that runs alongside the workload in the same pod and brokers all communication with the external network. It handles complex networking logic such as discoery, routing, and request splitting on behalf of the workload. The standard pattern involves the workload communicating with teh ambassador through localhost. As far as what type of logic it handles, ambassador containers remind me of gateways in Azure in a lot of ways. Although gateways are multi-node, centralized services where ambassador containers are single-node per instance architecture.