Notes from chapter Twelve - Event-Driven Batch Processing

# TL;DR
In chapter 11 we looked at work queue systems to accomplish batched processing operations. Chapter 12 expands on that by discussing how we link multiple work queues together to create an event driven, batched processing workflow.
A lot of the time these systems will follow patterns that involve connecting multiple work queues where each work queue accomplishes a very specific goal in the workflow as a whole. Such as having a data copier --> filtering system --> a data splitter and grouper --> compute sharder and load balancer --> result merger, style architecture
Pub/Sub architecture is important here. The publishing workflow sends messages / outputs to named queues. The subscriber workflow listens to those queues and picks up those messages or outputs for further processing.