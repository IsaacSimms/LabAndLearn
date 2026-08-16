# Entra ID Integration and Identity Management

**Topics:** Entra ID · User and Group Management · App Registration · Conditional Access · MFA  
**Duration:** ~0.75 hours

---

## Overview

This lab demonstrates integrating a web application with Entra ID for authentication, managing users and group permissions, enforcing conditional access policies, enabling MFA, and monitoring authentication activity.

---

## Scenario

A company wants to integrate their web application with Entra ID for authentication, manage user and group permissions, enforce conditional access policies, and enable multi-factor authentication (MFA) for added security.

---

## Steps

### 1. Create Users and Groups in Entra ID

1. Navigate to **Entra ID > Users > Create User**.
2. Create several users with distinct roles (e.g., Admin, Developer, Reader).
3. Navigate to **Groups > Create Group**.
4. Add the newly created users to the group.

---

### 2. Register an Application in Entra ID

1. Navigate to **App Registrations > New Registration**.
2. Provide the following:
   - **Name** — a descriptive application name.
   - **Supported account types** — select based on audience scope.
   - **Redirect URI** — the callback URI for your web application.
3. Under **API Permissions**, add Microsoft Graph permissions (e.g., `User.Read`).
4. Under **Certificates & Secrets**, generate a new client secret and store it securely.

> **Note:** Client secrets are shown only once at creation. Copy and store the value immediately.

---

### 3. Assign Users and Groups to the Application

1. Navigate to **Enterprise Applications** and select the registered app.
2. Go to **Users and Groups > Add User/Group**.
3. Assign the previously created groups to the application.

---

### 4. Configure Conditional Access

1. Navigate to **Entra ID > Security > Conditional Access > New Policy**.
2. Configure the policy:
   - **Users** — target all users or specific groups.
   - **Cloud apps** — select the registered application.
   - **Conditions** — optionally set location-based or device compliance requirements.
   - **Grant** — require MFA.
3. Set the policy state to **On**.
4. Test by signing in with different user accounts to verify enforcement.

> **Tip:** Use **Report-only** mode initially to evaluate policy impact before enabling enforcement.

---

### 5. Enable Multi-Factor Authentication (MFA)

1. Navigate to **Entra ID > Users > Multi-Factor Authentication**.
2. Enable MFA for the target users.
3. Sign in as an affected user and confirm the MFA prompt is presented.

> **Note:** Per-user MFA and Conditional Access-driven MFA are separate controls. Prefer Conditional Access-driven MFA in production — it provides finer-grained control and is the current Microsoft recommendation.

---

### 6. Monitor Sign-In Activity

1. Navigate to **Entra ID > Sign-ins**.
2. Review the sign-in logs to verify:
   - Successful authentications.
   - Failed attempts and their failure reasons.
   - MFA challenge results.

---

## Key Concepts

| Concept | Description |
|---|---|
| **App Registration** | Defines the application identity in the tenant. Produces a client ID used by the app to authenticate against Entra ID. |
| **Enterprise Application** | The service principal created from an App Registration. This is where user/group assignments and SSO are managed. |
| **Client Secret** | A credential the application uses to prove its identity. Treat as a password — store in Key Vault, never in source code. |
| **Conditional Access** | Policy engine that evaluates signals (user, device, location, app) and enforces access controls such as MFA or block. |
| **Per-User MFA vs. CA MFA** | Per-user MFA is a legacy control. Conditional Access policies are the recommended path for enforcing MFA. |
| **Sign-In Logs** | Audit trail of all authentication events. Essential for troubleshooting access failures and verifying policy enforcement. |
