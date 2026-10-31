---
question: What are the highest-leverage hands-on exercises, labs, and deliberate practice activities for improving macOS administration skills (profiles, configuration, Terminal, local admin troubleshooting, enrollment flows, common failure modes) for someone coming from a Windows-heavy shop?
researched: 2026-10-30
confidence: partial
versions:
  - apple/device-management release branch: Release-v27.2, commit 9e7fdbe, 2026-10-27
  - Apple Platform Deployment, About Apple device supervision: published 2026-09-17
  - Apple Platform Deployment, Enrollment methods for Apple devices: published 2025-01-28
  - Apple Platform Deployment, Device management restrictions for Mac computers: published 2025-03-31
  - Jamf Pro Documentation: 11.33.0
  - Jamf technical article, Reporting Capabilities in Jamf Pro: page checked 2026-10-30, no revision date shown
  - Jamf technical article, Methods to Achieve a User Approved MDM Status: page content checked 2026-10-30, no revision date shown
  - Jamf technical article, Pre-Approval of the Jamf Management Framework: page content checked 2026-10-30, no revision date shown
---

# What are the highest-leverage hands-on exercises, labs, and deliberate practice activities for improving macOS administration skills (profiles, configuration, Terminal, local admin troubleshooting, enrollment flows, common failure modes) for someone coming from a Windows-heavy shop?

## Answer

Apple does not publish a free hands-on lab catalog that can be completed without a Mac. The practice the current Apple schema and deployment docs do support is four short artifact drills: decide whether a profile replaces or adds, read a Security Information enrollment dictionary against a privacy-preferences payload, reject a supervised-only declaration on User Enrollment, and stop before the documented `profiles` rate limit. Confidence is partial because these drills are derived from those docs, not from an official lab workbook.

## Findings

No official free no-Mac lab catalog turned up in the Apple and Jamf sources below. The four drills are the shortest judgment tasks those sources can actually settle. Each answer is a fault plus the next check. Mock values use only keys and commands those sources define. They are not captured command output.

### Drill 1. Profile replace versus add

Ticket: a revised Wi-Fi profile was published to replace the installed one. Both still exist. The display name was left unchanged on purpose.

Installed profile and candidate:

```xml
<!-- installed -->
<key>PayloadDisplayName</key><string>Example Wi-Fi</string>
<key>PayloadIdentifier</key><string>com.example.wifi.v1</string>
<key>PayloadType</key><string>Configuration</string>
<key>PayloadVersion</key><integer>1</integer>

<!-- candidate -->
<key>PayloadDisplayName</key><string>Example Wi-Fi</string>
<key>PayloadIdentifier</key><string>com.example.wifi.v2</string>
<key>PayloadType</key><string>Configuration</string>
<key>PayloadVersion</key><integer>1</integer>
```

Fault: the top-level `PayloadIdentifier` values differ, so the candidate is an additional profile. The system uses that string to decide replace versus add. `PayloadDisplayName` is allowed to be shared and is not that key. `PayloadType` `Configuration` and `PayloadVersion` `1` are the required top-level values and are not the fault.

Next check: set the candidate's top-level `PayloadIdentifier` to `com.example.wifi.v1` if the intent is replacement. After that, an inner payload is updated on replacement only when its `PayloadIdentifier` and its `PayloadUUID` both match the installed payload.

On a real Mac: compare the installed profile's top-level `PayloadIdentifier` with the candidate before installing the candidate.

- The top-level `PayloadIdentifier` decides whether a profile replaces an existing profile or is added. — [T1] TopLevel.yaml (https://github.com/apple/device-management/blob/9e7fdbe/mdm/profiles/TopLevel.yaml)
- Top-level `PayloadType` has one supported value, `Configuration`, and `PayloadVersion` is `1`. `PayloadDisplayName` does not have to be unique. — [T1] TopLevel.yaml (https://github.com/apple/device-management/blob/9e7fdbe/mdm/profiles/TopLevel.yaml)
- During profile replacement, payloads update when `PayloadIdentifier` and `PayloadUUID` both match. The inner `PayloadDisplayName` does not have to be unique. — [T1] CommonPayloadKeys.yaml (https://github.com/apple/device-management/blob/9e7fdbe/mdm/profiles/CommonPayloadKeys.yaml)

### Drill 2. Privacy payload while user-approved MDM is false

Ticket: a Privacy Preferences Policy Control profile is still pending. Jamf inventory does not report User Approved MDM as "Yes". The computer is on a current macOS release, so this is not the advanced-search value "Unsupported OS Version" (that string is for macOS 10.13.1 or earlier).

Security Information `ManagementStatus` from the last query, and the payload being pushed:

```xml
<key>ManagementStatus</key>
<dict>
  <key>EnrolledViaDEP</key>
  <false/>
  <key>IsUserEnrollment</key>
  <false/>
  <key>UserApprovedEnrollment</key>
  <false/>
</dict>
```

Payload `com.apple.TCC.configuration-profile-policy`, macOS `userapprovedmdm: true`, `userenrollment.mode: forbidden`, `allowmanualinstall: false`.

Fault: `UserApprovedEnrollment` is false. When that key is false, the device may reject certain security-sensitive payloads or commands. This payload is marked for user-approved MDM. `IsUserEnrollment` is false, so the user-enrollment forbidden mode is not the matching rule.

Next check: make the enrollment user-approved before expecting a retry. Jamf retries a failed profile on a compatible computer every six hours, and "Send blank push" forces that attempt. A computer that fails the profile's requirements, including settings that require User Approved MDM, has to meet those requirements before the retry happens. Approval of an existing enrollment is System Settings > Privacy & Security > Profiles (System Preferences > Profiles on macOS 12 or earlier), the enrollment profile under Device Profiles, Approve. Jamf reports User Approved MDM as "Yes" after the documented approval paths. Push the profile from that MDM server. A manual click of the profile is not the install path Jamf documents for this payload without User Approved MDM.

On a real Mac: read `UserApprovedEnrollment` again after Approve, and confirm Jamf shows User Approved MDM as "Yes", before pushing this payload again.

- `UserApprovedEnrollment` false means the device may reject certain security-sensitive payloads or commands. `EnrolledViaDEP` true means Automated Device Enrollment. `IsUserEnrollment` true means the device is user-enrolled. The dictionary is `ManagementStatus` on the Security Information command, macOS introduced 10.13.2. — [T1] information.security.yaml (https://github.com/apple/device-management/blob/9e7fdbe/mdm/commands/information.security.yaml)
- In the schema, `userapprovedmdm: true` means the command can only be executed on a device with user-approved MDM enrollment. `userenrollment.mode: forbidden` means the payload cannot be used when user enrollment is in effect. `allowmanualinstall: true` means a user can install the profile manually. — [T1] docs/schema.yaml (https://github.com/apple/device-management/blob/9e7fdbe/docs/schema.yaml)
- Privacy Preferences Policy Control is `com.apple.TCC.configuration-profile-policy`, macOS 10.14 and later, device channel only, `userapprovedmdm: true`, `allowmanualinstall: false`, user enrollment forbidden. — [T1] com.apple.TCC.configuration-profile-policy.yaml (https://github.com/apple/device-management/blob/9e7fdbe/mdm/profiles/com.apple.TCC.configuration-profile-policy.yaml)
- Jamf's User Approved MDM inventory attribute is collected by the `SecurityInfo` MDM command on macOS 10.13.4 or later. An advanced search returns "Unsupported OS Version" for macOS 10.13.1 or earlier. A computer is reported as "Yes" when enrollment matches the article's approved cases. — [T2] Jamf Pro 11.33.0 General category (https://learn.jamf.com/r/en-US/jamf-pro-documentation-current/Computers_General_Category), Reporting Capabilities in Jamf Pro (https://learn.jamf.com/r/en-US/technical-articles/Reporting_Capabilities_in_Jamf_Pro)
- On an incompatible computer, including a profile whose settings require User Approved MDM, the computer must meet the profile requirements before Jamf's retry. On a compatible computer, Jamf retries every six hours, and "Send blank push" forces an attempt. — [T2] Troubleshooting a Failed Status of a Configuration Profile, Jamf Pro 11.33.0 (https://learn.jamf.com/r/en-US/jamf-pro-documentation-current/Troubleshooting_a_Failed_Status_of_a_Configuration_Profile)
- Approving an existing enrollment uses the Profiles pane and the Approve button, as the methods article describes. Installing this privacy profile with the `profiles` command or by clicking the profile does not work when management is the jamf binary without User Approved MDM; Jamf says it has to be pushed by MDM from a User Approved MDM server. — [T2] Methods to Achieve a User Approved MDM Status (https://learn.jamf.com/r/en-US/technical-articles/Methods_to_Achieve_a_User_Approved_MDM_Status), Pre-Approval of the Jamf Management Framework (https://learn.jamf.com/r/en-US/technical-articles/Pre-Approval_of_the_Jamf_Management_Framework)

### Drill 3. Supervised-only declaration on User Enrollment

Ticket: Writing Tools is still available on a personally owned Mac running macOS 26.4. Enrollment is account-driven User Enrollment. The declaration below was delivered.

```yaml
declarationtype: com.apple.configuration.intelligence.settings
# macOS introduced: 26.4
# allowed-enrollments: [supervised]
AllowWritingTools: false
```

Fault: the declaration's allowed enrollment list on macOS is only `supervised`. Account-driven User Enrollment is not supervised. `AllowWritingTools` false is the documented way to disable Writing Tools (the default is true), and macOS 26.4 meets the introduced version, so neither the boolean nor the OS version is the fault.

Next check: Device Information `IsSupervised`. True means the device is supervised. This enrollment method's row in the enrollment table is "No" for supervised upon enrollment.

On a real Mac: open System Settings > General > Device Management. The supervision line "This Mac is supervised and managed by [Organization name]." is how Apple says to identify a supervised Mac. Its absence fits this enrollment method, and this declaration still does not apply.

- Account-driven User Enrollment (macOS 14 and later) is not supervised on enrollment. Profile-based Device Enrollment and account-driven Device Enrollment are supervised on a Mac. Automated Device Enrollment is supervised. The same page's enforceable-restrictions cells are "Curated list", "Unsupervised only", "Unsupervised only", and "All" for those four methods, in that order. — [T2] Enrollment methods for Apple devices, published 2025-01-28 (https://support.apple.com/guide/deployment/enrollment-methods-for-apple-devices-dep08f54fcf6/web)
- `IsSupervised` true means the device is supervised. On macOS the key was introduced in 10.15. — [T1] information.device.yaml (https://github.com/apple/device-management/blob/9e7fdbe/mdm/commands/information.device.yaml)
- `com.apple.configuration.intelligence.settings` on macOS was introduced in 26.4 and lists `allowed-enrollments: [supervised]`. `AllowWritingTools` false disables Writing Tools. The schema describes `allowed-enrollments` as an array of allowed enrollment types, and `supervised` is one of those types. — [T1] intelligence.settings.yaml (https://github.com/apple/device-management/blob/9e7fdbe/declarative/declarations/configurations/intelligence.settings.yaml), docs/schema.yaml (https://github.com/apple/device-management/blob/9e7fdbe/docs/schema.yaml)
- The Mac supervision indicator is the line "This Mac is supervised and managed by [Organization name]." in System Settings > General > Device Management. — [T2] About Apple device supervision, published 2026-09-17 (https://support.apple.com/guide/deployment/about-device-supervision-dep1d89f0bff/web)

### Drill 4. `profiles` rate limit

Ticket: a script was retrying enrollment status on a Mac that is in Apple Business, organization-owned, running macOS 13 or later. In the last 24 hours the script invoked these command names 11 times in total: `profiles show`, `profiles validate`, and `profiles renew`. No error text was captured.

Fault: on macOS 13 and later, for an organization-owned Mac whose serial appears in Apple School Manager or Apple Business, those three requests together are limited to 10 per 24 hours. This log is past that cap. `profiles -N` is not in the limited set.

Next check: stop the loop and let the 24-hour window pass. Renewing supervision, when that is actually the task, is a single `sudo profiles renew -type enrollment` or `profiles -N` on a Mac enrolled in an assigned MDM service whose serial appears in Apple School Manager or Apple Business.

On a real Mac: run one of those renew commands once, or one `profiles show`, and do not loop the three limited names.

- The 10-per-24-hours limit covers `profiles show`, `profiles validate`, and `profiles renew` for organization-owned devices that appear in Apple School Manager or Apple Business, on macOS 13 and later. The supervision-reset commands are `sudo profiles renew -type enrollment` and `profiles -N`. — [T2] About Apple device supervision, published 2026-09-17 (https://support.apple.com/guide/deployment/about-device-supervision-dep1d89f0bff/web)

## Recommendation

Use these four drills, in this order, and stop. They are about a 40-minute pass and they train the escalation split a Windows admin actually needs: identity of the profile, enrollment flags on the Security Information dictionary, supervised versus User Enrollment, and not polling `profiles`. The tradeoff is that none of them produces the System Settings click-path or a real install failure. That remainder waits until a Mac is available, and the one-line re-run at the end of each drill is the whole on-device follow-up worth keeping. A certification course is a poor fit for this time budget: Apple's own exam prep says to gain direct experience and to perform the course exercises, on the order of tens of hours, and those exercises are not published here as a free no-Mac workbook.

## Ruled out

- Apple Training courses and practice exams as the drill source. The public training pages describe self-paced Device Support and Deployment and Management courses and say to perform the exercises; the Deployment and Management exam prep guide says to gain practical experience deploying and managing devices and allows on the order of 30 to 60 hours. That is a certification path with device time, which this budget excludes. Checked https://training.apple.com/ and https://training.apple.com/content/dam/appletraining/us/en/2025/documents/Apple%20Deployment%20and%20Management%20Exam%20Prep%20Guide%20EN.pdf (search extracts, 2026-10-30).
- On-device labs and cloud Mac rental. Out of scope for the question, and not required by any source above.
- A `profiles` man page with list or remove flags. `https://developer.apple.com/library/archive/documentation/Darwin/Reference/ManPages/man1/profiles.1.html` returned 404. The supervision page names the commands used in drill 4 and does not document their output, so no sample error string is included.
- The legacy Configuration Profile Reference PDF at https://developer.apple.com/business/documentation/Configuration-Profile-Reference.pdf. It still describes top-level keys, including a shorter `PayloadRemovalDisallowed` cell. Drill answers use the device-management schema at Release-v27.2 instead. No PDF revision date was found in the extracted front matter.
- Enrollment-method checkmarks for FileVault, remote wipe, and the other ability rows. The 2025-01-28 enrollment page's markdown extraction left those cells blank. Only the "Enforceable restrictions" row had text values, and it is cited above. It was not turned into a fifth drill because the restrictions table's "Supervised" column is not defined in a sentence on that restrictions page (published 2025-03-31).
- `mdm/commands/security.info.yaml`. That path 404s. The command file is `mdm/commands/information.security.yaml`.
- Community labs, MacAdmins posts, and tutorial walkthroughs. Not used as evidence.

## Open questions

- A Mac enrolled with profile-based Device Enrollment is supervised, and the enrollment table still lists that method's enforceable restrictions as "Unsupervised only", while Automated Device Enrollment is "All". The intelligence declaration allows the enrollment type `supervised`. Whether a profile-based Device Enrollment Mac satisfies that list is not settled by reading those two pages together.
- `PayloadRemovalDisallowed` in TopLevel.yaml says that on macOS 10.15 and later the key only affects manually installed profiles, and that users cannot remove MDM profiles, while the key's `supportedOS` block in that file lists iOS and tvOS and not macOS. Jamf's enrollment article says Automated Device Enrollment is the only method that can prevent end users from removing the MDM profile (https://learn.jamf.com/r/en-US/jamf-pro-documentation-current/Enrollment_into_Jamf_MDM, search extract). Whether "MDM profiles" in the schema means the enrollment profile is unresolved, so no drill uses that key.
- Jamf documents User Approved MDM as "Yes" and, for old advanced-search results, "Unsupported OS Version". The string shown when a supported OS is not user-approved is not specified. Drill 2 therefore uses Apple's boolean `UserApprovedEnrollment`, not an invented Jamf value.
- The supervision page does not document the text `profiles` prints when the 10-request cap is hit, or when `profiles show` is run with no arguments.
