# Notes from chapter 10 - Ownership Election

## TL;DR
As we know, it is common for multiple different nodes to be operating on the same workload in a distributed system. 
However, there are common use cases where a single process must own a piece of work or data at any given time. This is where theory behind distributed ownership comes into play.
This is where we get into leader / ownership election. That is the process of selecting a relpica that is allowed to exclusively perform a task or operation at any given time. 
The simplest way to handle this deligation is to run the service as a singleton. This is at is sounds, there is only one replica of the service that is able to interact with the data that requires a lock. However, this does not scale wall and does not work in many use cases.
For high availability, scalability, fault tolerance, etc. the distributed key-value store pattern is commonly used. 
This is where a key is introduced into the system. That key is treated as a lock. Whichever replica owns the key is able to interact with the defined data or process.
If a replica does not own the key, they cannot interact with the data or process. A compare and swap operation is introduced to manage the exchange of that key between replicas under certian circumstances.
The key will also have a time-to-live value, which is an automatic expiration of the lock. This prevents a crashed or unresponsive replica from holding the lock indefinitely.
Also means that the replica owning the lock renews the lock every time-to-live value in order to maintain ownership. 

## Outline
### Core
Use when task requires exclusive ownership of data or process.
Singleton Kubernetes architecture works for some use cases
Distributed locks are more common in large scale prod systems. 

### Singleton
A defined architecture in Kubernetes.
Acceptable for some background jobs with low load that is well known.
Uptime can be decent but is not a viable option at all if any outage, downtime, or failure is unacceptable. 

### Distributed locks
#### Defintions
Lock: a key a replica holds which allows them to interact with a process or data. No lock = cant interact.
Time-to-live (TTL): Automatic and predefined experation of that lock. Prevents unresponsive replica holding lock indefinitely. Forces active replica to renew lock. 
Compare and Swap (CAS): Atomic operation that handles the exchange of locks between replicas under predefined conditions.
#### General / best practices
Always acquire locks via CAS operations that allow for the exchange of that lock between replicas. Never hardcode a lock to a replica.
Always define a TTL so crashed server does not hold lock.
Use a resource version and/or precondition on unlock so a replica only ever unlocks its own lease.
If renewal of a lock's lease fails that means the replica in question has lost the lease to a different replica. It needs to stop operations.
Do not have crazy long TTLs.