# Notes from Chapter Seven - Sharded Services - notes

## TL;DR
Think about chapter six replicated load balances services. That is multiple identical replicas of the same servicess accross multiple services behind a load balancer. Any one replica is able to handle any request.
Now, compare that to a sharded service. Each server holds a subset of the service (referred to as a shard) and can only handle a portion of the potential requests. There is a load balancer/root that routes the request to the proper shard.
Lots of architecture and logic goes into to getting this to work. Sharding functions, a shard key, hashing, etc.

## Outline
### Core
Replicated architecures are commonly used for stateless services (user state does ont need to persist) where a sharded service is used for stateful services (user state does need to persist accross requests or long sessions.)
Each shard only handles a subset of requests.
Root/balancer examines requests and routes properly

### Why
state of a session/request is to large for a single machine.
Request isolation is also a benefit.

### Sharded cache
Much like a cache as discussed in previous notes, but follows the sharding architecture.
Improvement to memory utilization and hit rate.
cold or failed shard in a cache can lead to a failure for end user.
#### Replicated Sharded caches
Each cache set in the architecture has replicas.
Introduces failure tolerance and scaling. Makes hot sharding easier.
#### Sharding function
A logic based function that maps a request to a specific shard. Having a good key and making sure the function is deterministic is very important here. 
Good use of hashing will minimize key movement. 