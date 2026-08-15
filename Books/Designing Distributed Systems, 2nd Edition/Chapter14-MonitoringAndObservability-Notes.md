# Notes from chapter 14 - Monitoring and Observability patterns

## TL;DR
Distributed systems are usually running services. Services are running 24/7. It is unreasonable to expect contant hands on monitoring of logs or metrics. Any good distributed system required robust architecture around
observability into the system, and alerting to the proper POCs when things go wrong. 
Looging, metrics, alerting, and tracing are key patterns discussed.

## Outline
### Core
Services always on and always being used == need automated architecture for figuring out problems before users do.
Need both detection and alerting logic (specific things logged == alert to on call eng sent) and then also understanding (more in depth logs such as debugging logs when required, metrics, traces.)

### Logging
records of what happened within a **specific executuion**. The play by play. classic .log file. 
Log spam needs to be managed. Only log what is required, which can be a hard problem to solve.
Libraries can be added to allow things like timestamps, log levels, user context.
Log levels: Debug --> info --> warning --> error --> fatal... know the difference. 
Good default is info/warning only for standard logging, error triggering alerts, and debug only turned on when needed.
Common to only log errors and weird, out of norm cases to avoid log noise. 
Consider conditional logging.

### Metrics
Aggregate **statistics** over time. think traditional statistics
Histograms. good for latency tracking.
Counts. incrementing whole values. good for total requests.
values / gauges. Could go up or down and be decimals. good for tracking cpu / memory usage. 

### Alerting
Rule (action) fires when a threshold is crossed. Common to fire off a predefined script and / or notify humans.
Thresholds are static and end up defining SLOs
balance the user experience against on call load. You do not want a poor user experience but you also do not want to burn out on call devs or engs. 
think about anomaly detection to avoid alerting for one off cases. 
every metric does not need an alert.

### Tracing
used to track individual service calls into a single end to end user experience. (Remember, most modern end user experiences involve requests to more then one service)
assign identify to the tracing workflow and keep it at the edge of the system.
Think about what that full path you are wanting to track is, then propagate the workflow thorugh every service. Attach logs and / or metrics to it or its useless.