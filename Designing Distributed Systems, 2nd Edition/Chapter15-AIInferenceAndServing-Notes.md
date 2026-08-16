# Notes from Chaper 15 - AI Inference and Serving

## TL;DR
ML, RAG, SL, AI engineering, etc. are all their own disciplines with their own expertise. However, It is common for model hosting and / or AI inference to become another service within your distributed system. The eng managing the distributed system will manage the infrastructure, the eng manaing the service managed the model/rag/etc.
Often to train or fine tune a model rarely and serve it as a REST API to the rest of the system.
Models can be hosted on prem or by using a cloud inference service (big public cloud providers all have one)
RAG is the industry standard for injecting current or user specific context into prompts.
Tests are statistical analsis at scale over unit testing. 

## Outline
### Core
Model: A set of numeric weights that act like a learned function.
TRaining: Feeding a crap load of data to the model to build input == output.
Inference: feeding prompts and returning output at scale. the whole point.
Prompt: user's text plus all related context.

### Hosting a model
Need to have low latency, realistically requires GPUs (atm)
Expensive and hardware intensive. Cant run it on a phone as an example. Common to use cloud inference, model providers, and big ol on prem infa.
Small language models exist for where use cases apply.

### Model distribution
Look into open formats like ONNX
You can download open weight / source models straight off of the internet.
Cache models locally. Not tennable to download the whole thing every use. 
Always do progressive expose when deploying new LLM models.

### practices
use a REST API for inference.
dev and test envs should use SLMs that are similar to teh prod LLM.
continuous eval.

### RAG (retrieval-augmented generation)
At current state of tech models only have the info they where exposed to during training without RAG.
RAG = system runs queries against on prem database for user info, the internet for up to date info. etc. and injects that into prompt.
keeps personal data out of weights and allows models to have up to date info.