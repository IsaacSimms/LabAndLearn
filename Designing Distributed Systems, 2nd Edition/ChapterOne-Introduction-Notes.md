# Notes from Chapter One - Introduction 

## TL;DR
Modern computing environments demand availability, reliability, and the ability to scale at insane rates. This forces production systems into a distributed context in most circumstances. Building these systems has been historally difficuult, and bespoke with a small class of humans able to perform at a very high level. Containers, orchestrators, and related infrastructure has provided us with the building blocks to reuse, share, and modify established architecture. (Think what OOP did for programming) This book focuses in on general must knows for the art of distributed systems and more specifically, commonly used patterns. 

## Outline
### Why Distributed systems matter
Always on and need for scale, management, and fault tolerate lead just about every prod system to be distributed to one extent or another
more reliable and teams can also scale with the system
But: these systems are much harder to design, build, maintain, and debug

### Short history
All compute used to happen on a single machine. Then, a progression started to play out as performance, security, and reliability became more demanding. Single boxes-->client-server-->large scale distributed systems (started in the early 2000s)

### Important milestones for distributed systems
Algorithms
OOP design patterns (Gang of four)
Open Source

### What is a distributed system pattern and why they matter
Blueprint
no specific tech stack required
applies to many different systems
learn from others instead of making the same mistakes over and over
shared langauge
modular, editable components