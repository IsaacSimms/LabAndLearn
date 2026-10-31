# How to use this research

Start here. This folder is a short escalation briefing for Isaac, who is moving into an IT Systems Administrator role at EquipmentShare (Corporate HQ, Columbia, MO). He is the technical escalation point for IT Support. He already knows Windows endpoints (Intune/SCCM), Okta, and hybrid AD/Entra. Mac and Jamf depth is limited. He has no Mac hardware to practice on, and he will not spend long sessions on this.

Researched 2026-10-30. Every research file is confidence **partial**. Claims are from Apple, Google, Jamf, Okta, and Iru primary docs. Do not fill gaps from blogs, courses, or memory.

## If you are the agent

1. Read this file.
2. Open only the research file that matches the task. Read **Answer**, then **Recommendation**, then **Open questions**.
3. Open **Findings** only for the object the task names.
4. If the task is one of the open questions below, say it is unresolved. Do not guess a tenant-specific answer.
5. Keep the session short. A useful pass is the Answer plus the Recommendation. A drill pass is one drill, not all four, unless he asks for the set.

## Constraints that are already decided

- Jamf means **Jamf Pro**, current cloud docs in these notes (11.33.0). Jamf Now is only a product distinction. Jamf School is out of scope.
- Google Workspace and Iru notes use current public docs. Edition gates are noted where the docs state them. Do not assume EquipmentShare's SKU, Okta wiring, or Iru migration date.
- Practice is mock tickets and artifacts. Do not assign a cloud Mac, a wipe lab, or a certification path.
- A Jamf Pro to Iru move is a new enrollment and a new scope design. "Upgrade to Iru" in the Iru docs is a Kandji-tenant cutover, not a Jamf import.

## Which file

| Task | File | Read first |
|---|---|---|
| Google Workspace ticket: SSO, users, groups, licenses, shared drives | `google-workspace-sysadmin-essentials.md` | The four-layer check in Answer |
| Mac endpoint ticket in Jamf Pro | `jamf-essentials-windows-sysadmin.md` | The two-channel split in Answer |
| Practice with no Mac | `mac-admin-practical-exercises.md` | One drill. The set is four drills, about 40 minutes |
| Jamf Pro to Iru transition | `iru-platform-overview.md` | Answer, then Blueprint moves and EDR |

## How to work a ticket

**Google Workspace.** Walk four layers before changing a domain-wide SSO profile or a Drive sharing default:

1. Okta assignment and provisioning result
2. The user's effective Google SSO profile (organizational unit or group)
3. License, and whether the account is suspended, archived, or deleted
4. The service setting that won, including the shared drive's own organizational unit when the ticket is Drive

Super admins use a Google password at `admin.google.com`. Newer SSO profiles do not sign them in. Several of these controls can take up to 24 hours.

**Jamf Pro.** Split the channels before editing anything:

- Apple MDM and declarative management: enrollment, configuration profiles, remote commands. Look at Management History.
- Jamf management framework: policies, packages, scripts, inventory. Default recurring check-in is 15 minutes. Look at the policy log and at scope (targets, limitations, exclusions).

Scope removal leaves settings a policy already applied. A log entry can block a "once per computer" policy until the log is flushed. The Jamf 11.33.0 docs do not define Intune or SCCM equivalents. Do not invent a mapping table.

**Iru.** Each device has one Blueprint. Assignment Map rules cover exceptions that used to be extra smart groups. Enforced Auto Apps and Custom Apps stay installed when a Mac changes Blueprints. Confirm EDR, Vulnerability Management, Identity, and Compliance on the Billing page before planning those workstreams. Windows EDR, when licensed, reports and does not quarantine.

## Practice

Do the drills in `mac-admin-practical-exercises.md` in order when he wants practice. Each drill is a ticket, a fault, and the next check. Stop when time is gone. The highest-signal pair is drill 1 (profile identity) and drill 2 (user-approved MDM).

## Leave these unresolved

- Google: Okta says a deleted username cannot be reused for a week. Google Admin Help allows reassignment during the 20-day restore window.
- Jamf Pro: whether a configuration profile is removed when a Mac leaves scope.
- Drills: whether a Mac from profile-based Device Enrollment satisfies a declaration limited to the `supervised` enrollment type. The same Apple table still marks that method's restrictions as unsupervised only.
- Iru: when to reassign a device in Apple Business Manager, whether a wipe is required, and what inventory survives. The docs only say another MDM blocks enrollment.
