# Notes from Chapter Six - Replicated Load Balanced Services

## TL;DR
This chapter signifies the departure from single node architecture. Here, we look a pattern that involves identical replicas of a service (server replicas more specifically). 
Each replica of the service is able to completely handle any request that service may receive.
In this specific pattern, all of these replicated servers sit behind a load balancer. The load balancer handles delegation of requests to the different servers based on predefined configs.
You are able to add functionalities like readiness probes, session stickiness, etc. as needed. Although features like that can add complexity to the system. 
A common pattern used for efficient scaling (add more servers behind the same load balancer) and high availability (never take more then one server behind the same load balancer down at the 
same time. Cut over to online server if one fails)

## Outline
### Core 
Always multiple **identical** replicas of the service running on multiple servers
Load balancer sits in front and handles request delegation
service redundancy and horizontal scaling

### replication/redundancy
Single replicas are failure points waiting to happen. One upgrade, crash, etc. causes the whole service to fail. 
For small, low use services often times only 2-3 servers are needed and drastically increase the SLA of the service as compared to one replica. 

### Readiness probes
Important to understand the difference between readiness probes and liveness probes. 
Liveness probes = is the service alive/online to any extent? 
Readiness probes = is this service able to take a request?
If a server is online and initializing a configuration file it would pass a liveness probe since it is indeed online, but it would not pass a readiness probe since it cannot take a request. 
**Use readiness probes for load balancers**

### Session tracking
Some services are long running and/or store some sort of user information locally to provide a service. 
These services require session stickiness. Which means that all requests from one user in one session go to the same replica.
Can be done with IP Hashing. Depending on the use case, often times best practice to use cookies or HTTP headers at the application level for session stickiness logic.

### Application Layer notes
#### Caching layer
A server layer that sits between the end user request and the application replicas. 
Stores responses to requests in the caching layer server's memory. When the same exact, byte for byte, request comes in the cache answers that request instead of having that request reach
the application layer. Common architecture is a HTTP reverse-proxy cache (Vanish is a good example). Lightens the load of multiple same user requests off of the application layer. 

#### Rate limiting and DoS defense
There are many different ways to add DoS defenses are prevent misuse of your infrastructure. 
Examples include throttle requests based on IP, forcing a logged in status for requests, 429 returns at the HTTP protocol layer, etc.

#### SSL Termination
You can have a nginx layer that terminates TLS and forces that to a cache layer rather then allowing those request get to the application replicas. 
Often times different certs for edge, internal, and development services to get around your SSL termination

#### Layered pattern
Often times production infrastructure is going to take a layered approach with multiple of these layers working in tandem. Multiple layers are passed through before a client request could
ever get to a application replica. 
Example:
external request --> SSL termination wall (nginx) --> a caching layer such as Varnish servers --> application replicas. 
