# Research Prompt: EquipmentShare IT Systems Administrator Upskilling

Follow the research skill exactly. Produce four separate research markdown files under `docs/research/`. Each file must use the research skill output format (frontmatter with question/researched/confidence/versions, Answer, Findings with T1/T2/T3 citations, Recommendation, Ruled out, Open questions).

Use only primary sources. Tag every claim with its tier. Stop per question when answered or after three consecutive sources add nothing new. Hard ceiling ~20 fetches per topic. If inconclusive, report that clearly.

**Context for all research**  
Isaac is moving into an IT Systems Administrator role at EquipmentShare (Corporate HQ, Columbia, MO). The role is the technical escalation point for complex issues from IT Support. Environment is Mac-heavy (Jamf currently; planned transition to Iru). Isaac has strong Windows endpoint (Intune/SCCM), Okta, hybrid AD/Entra, and infrastructure experience but limited Mac/Jamf depth. Goal is practical readiness for succession: troubleshooting, administration, and project work across endpoint, identity, and related systems. Focus on what a systems administrator actually needs to escalate and resolve issues, not deep specialist certification paths.

## File 1: Google Workspace Enterprise Admin Essentials
**Output path:** `docs/research/google-workspace-sysadmin-essentials.md`  
**Question:** What are the core Google Workspace admin concepts, tools, and troubleshooting patterns an IT Systems Administrator needs for enterprise escalation work (Admin console, directory/users/groups, shared drives, security & compliance controls, common Okta/IdP integration points, and frequent failure modes)?

Cover practical depth for someone who already understands Okta/Entra IAM: what changes in the Workspace model, key admin surfaces, and the most common issues that reach escalation.

## File 2: Jamf Essentials for Windows-Background SysAdmins
**Output path:** `docs/research/jamf-essentials-windows-sysadmin.md`  
**Question:** What must a systems administrator with strong Intune/SCCM experience know about Jamf (concepts, architecture, core objects, policies, smart groups, prestage enrollment, packages/scripts, inventory, and common troubleshooting patterns) to handle Mac endpoint escalation effectively?

Map Intune concepts to Jamf equivalents where useful. Emphasize operational reality over marketing.

## File 3: Practical Mac Administration Exercises and Skill Builders
**Output path:** `docs/research/mac-admin-practical-exercises.md`  
**Question:** What are the highest-leverage hands-on exercises, labs, and deliberate practice activities for improving macOS administration skills (profiles, configuration, Terminal, local admin troubleshooting, enrollment flows, common failure modes) for someone coming from a Windows-heavy shop?

Prioritize free or low-cost methods that build transferable troubleshooting ability. Include recommended sequence and what “done” looks like for each exercise.

## File 4: Iru Platform Overview and Transition Considerations
**Output path:** `docs/research/iru-platform-overview.md`  
**Question:** What is the Iru platform (formerly Kandji), its core products and architecture (endpoint management, identity, security/EDR, compliance), how it differs from Jamf, and what systems administrators need to know when an organization is transitioning to it?

Focus on operational differences, migration realities, and day-to-day admin implications rather than sales claims.

---

Execute the four research threads (parallel is fine). Write each file completely. Return the four file paths plus a short summary of confidence level and any major open questions for each.