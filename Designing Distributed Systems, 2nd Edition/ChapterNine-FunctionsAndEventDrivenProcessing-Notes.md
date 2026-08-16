# Notes from Chapter Nine - Functions and Event-Driven Processing

## TL;DR
Up until this chapter we have been looking at patterns that revolve around persistent, always on workloads in server architectures.
Chapters 9 mark a transition to architectures built for short-lived "one shot" workloads. Functions are designed to run for a short period of time and are
triggered by some sort of event coded into the workload. A well built Function-as-a-Service (FaaS) scale automatically and require no long running server.
These architectures are not for sustained traffic, background jobs, or large jobs requiring a lot of data in memory.
Instad, ideal use case candidates include response decoartion, engineer dispatch functionalities, event handlers, and event pipelines.

## Outline
### Core
The Function code only runs when the event or request arrives at its doorstep. Something else usually delivers that request/event.
Scaling and management is automatic.
Stateless

### Benefits
Easily scaling and failure tolerance. (FaaS specifically)
Modular and decoupled by design, works with my different workloads.
Fast and simple to stand up in an environment.

### Drawbacks
Requires strong monitoring and can go awry pretty easily. Accidentally making continuous loops is possible.
Difficult to debug.
Difficult to get a picture on how the functions interact with our environment as a whole, and particularly difficult to understand how different functions interact. Especially if you have them wired together or a lot of them in your environment.

### Types
#### Decorator
Think back to the sidecar pattern here. The function sides beside the workload as an argument.

#### Event handling and event handling pipelines
Asynchronous events are triggered by something external to the function. The function takes that event (often with parameters provided by the event) and performs some sort of action. 
Common example used is user-sign up happens --> that event is fed into function with user email as parameter --> function sends welcome email to user.
Other common use cases are file upload = some sort of action with that data or 2fa request = code sent to phone. 
All this applies to pipeline as well. The pipelines are multiple functions wired together to complete a goal. 