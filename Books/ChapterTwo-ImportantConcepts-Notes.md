# Chapter 2 - Important Distributed System Concepts - notes

## TL;DR
This chapter revolved around core concepts and things that you must understand before designing distributed systems. Wiring (APIs/RPCs), measuring (latency, reliability, precentiles), failure handling (idempotency and delivery guarantees), data correction (relational and consistency data models), orchestrators, health checks.

## Outline
### APIs and RPCs
Calls between services and boxes, usually HTTP plus JSON
Sync (wait for answer) vs async (returns operation ID during execution)... need async during executions that take a long time
SLOs (formal targets) for important metrics such as latency, reliability, and throughput.
RPC: Remote procedure call - an API call that travels over a network

### Latency
The time in which it takes to do something
Needs to be attributable (difficult to look at one call and assume user experience. Need to look at the aggregate of calls)

### Reliability
Fraction of successful requests
HTTP returns codes no matter what, difficult to determine

### Precentiles
Pure average gives outliers to much weight.
Use 90th or 99th (as examples) of total dataset to get better idea of actual user experience.

### Idempotency
The concept that doing the same action many times causes the same result
int x = 5; Console.WriteLine(x); // indempotent
int x = 5; x + 1; Console.WriteLine(x); // not indempotent due to the increment

### Return Semantics
At-least-once = delivery happens one more more times
At-most-once = delivery happens one or zero times

### Relational Integrity 
The more relational, the more of a guarantee theres is consistenty of related data accross stores. The more relational a data set is, the less performant it is. (generally)
SQL = strong relationality... no-SQL = weak relationality

### Data Consistency
Strong = data is the same in all places before a success is posted
eventual = one write means we are good and then everywhere else catches up
strong is safe but slow. eventual is fast but risky

### Orchestration
A term for the platform that controls the infrastructure and state
This is where some of the architectural decisions are made to build out a distributed system (such as we need 5 VMs behind a load balancer to run the backend of the web app)