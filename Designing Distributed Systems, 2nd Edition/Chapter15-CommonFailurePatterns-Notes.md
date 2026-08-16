# Notes from chapter 15 - Common Failure patterns

## TL;DR
Outlines what not to do
If you implement blind retires after failures, thundering herds are common. (Thundering herds are when retries get grouped with new requests over and over)
Not having failures or logging is indicative of an issue as well. Need to have alerting for that.
Common mistake is to under appreciate errors. Not all api errors are harmless or noise.

## Outline
### Thundering herd
Overload or error == timeouts --> clients all retry + new requests = even more load and collapse
### Absence of error
steady state systems almost always have ambient error noise. No errors likely == errors.
### Client and / or expected errors
Easy to ignore things like auth or validation failures. a vast majority are client side. Be sure you are aware of large spikes though.
Synthetic requests such as test accounts are really helpful in verification here
### Versioning errors
Make sure you have distint representations of all versioning in your metrics / logging / etc. is important.
### Processing obsolete work
During an outage a backlog of now obsolete work will pile up. Then a service comes back online and tries to process it.
### Summary
There are many more failure modes then could be outlined here. More so then building around any one failure mode: learn the recurring failure modes and design against the underlying architecture failures rather then repeating the same mistakes. 