# Notes from Chapter Seven - Sharded Services - notes

## TL;DR
Think about chapter six replicated load balances services. That is multiple identical replicas of the same servicess accross multiple services behind a load balancer. Any one replica is able to handle any request.
Now, compare that to a sharded service. Each server holds a subset of the service (referred to as a shard) and can only handle a portion of the potential requests. There is a load balancer/root that routes the request to the proper shard.
Lots of architecture and logic goes into to getting this to work. Sharding functions, a shard key, hashing, etc.

## Outline
### Core
Replicated architecures are commonly used for stateless services (user state does ont need to persist) where a sharded service is used for stateful services (user state does need to persist accross requests or long sessions.)