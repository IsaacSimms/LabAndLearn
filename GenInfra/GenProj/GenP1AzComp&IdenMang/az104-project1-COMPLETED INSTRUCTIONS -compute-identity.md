# AZ-104 Project 1: Azure Compute and Identity Management

**Topics:** VMs, RBAC, Azure AD (Entra ID), Azure Policy, Encryption, Cost Management  
**Estimated Time:** ~0.75 hours

---

## Scenario

Deploy a virtual machine for a web application, secure it with RBAC, enforce a naming/tagging policy via Azure Policy, encrypt sensitive data using Key Vault, and monitor costs.

---

## Steps

### 1. Create a Virtual Machine

1. **Azure Portal** > **Virtual Machines** > **Create**
2. Configure:
   - Subscription, resource group, region
   - VM size and OS (Windows/Linux)
   - Admin username + SSH key (**use Ed25519**, not RSA — better security, smaller key)
3. **Add a data disk:**
   - Create new disk > **None** (standard blank disk)
   - *Storage Blob option* = reuse existing disks or custom VHDs from outside Azure
4. **Configure Networking:**
   - Assign a static private IP via **Advanced Networking**
   - Attach a **Network Security Group (NSG)**:
     - `None` — manual NIC management only
     - `Basic` — auto-generated rules, suitable for dev/test
     - `Advanced` — attach a pre-configured NSG; use for production
5. Review and create → **download the private key**

> **Cost tip:** Always deallocate (not just "Stop" from OS) when done. Deallocated = no compute billing. Delete throwaway lab VMs entirely.

---

### 2. Configure Role-Based Access Control (RBAC)

**Create a Key Vault and store the private key:**

1. **Key Vault** > **Create** — same resource group, same region (required)
2. **Entra ID** > **Groups** > Create group → add yourself as owner and member
3. **Key Vault** > **IAM** > **Add Role Assignment** > `Key Vault Administrator` > assign to your group
   - Sign out and back in to refresh your token if permissions don't propagate
4. **Key Vault** > **Objects** > **Secrets** > **Generate/Import** > Manual → paste the contents of your `.pem` key file as the secret value
   - *Why Secrets, not Keys:* Key Vault Keys are for cryptographic operations (encrypt/decrypt/sign). Azure Key Vault does not support Ed25519 as a key type; and even for RSA, importing as a Key is not the intended path for SSH material. Secrets store arbitrary sensitive strings — a PEM file's contents is exactly that.

**Assign VM-level RBAC:**

1. **VM** > **Access Control (IAM)** > **Add Role Assignment**
2. Assign `Virtual Machine Contributor` (or a custom role) to the user/group
3. Verify: **Entra ID** > **Groups** > select your group

> **Principle:** Assign the minimum required permissions (least privilege). Never assign Owner or Contributor at subscription scope unless necessary.

---

### 3. Connect to the VM via SSH

1. **VM** > **Connect** > **SSH using Azure CLI** > Configure
2. In the CLI panel:

```bash
az network public-ip list
```

3. Test the public IP in a browser — should be inaccessible via HTTPS, only reachable via SSH (enforced by NSG rules)

---

### 4. Apply Azure Policy

**Create an Initiative (policy set):**

1. **Azure Policy** > **Authoring** > **Definitions** > **Initiative definition**
   - Set Name, Category > **Next**
2. **Add policy definitions:**
   - Search `tag` → add several *"Inherit a tag from resource group"* and *"Inherit a tag from subscription"* policies
   - Search `allow` → add `Allowed resource types`
   - **Review + Create** > **Next**
3. **Create a group** named `Tags` > Save
4. Assign tag policies to the `Tags` group
5. **Initiative parameters** > Create parameter:
   - Name, Display Name, Allowed Values > Save
6. For each tag policy reference, set:
   - Value Type: `Use Initiative Parameter`
   - Value: `Name`
   - For `Allowed resource types`: set to `virtualMachines`
7. **Review + Create**

**Assign the Initiative:**

1. Select scope = your subscription
2. Set parameters
3. **Review + Create**

**Verify compliance:**

- **VM** > **Operations** > **Policies** — view compliance state

---

### 5. Monitor and Manage Costs

1. **Cost Management + Billing** > **Budgets** > **Add**
   - Set a monthly spending limit for the subscription
   - Configure alert thresholds (e.g., 50%, 80%, 100%) via email or Action Group
2. Review **Cost Analysis** for spending trends
3. Review **Azure Advisor** recommendations for cost optimization

---

## Key Concepts to Retain

| Concept | What to Know |
|---|---|
| Subscription | Billing + identity boundary; all resources live inside one |
| Resource Group | Management boundary; lifecycle container; RBAC and Policy scope |
| NSG | Stateful L4 firewall; attach at subnet or NIC level |
| RBAC | Role assignments cascade down the hierarchy (MG > Sub > RG > Resource) |
| Key Vault | Centralized secret/key/cert store; access controlled via RBAC or access policies |
| Azure Policy | Enforce governance at scale; Initiatives group multiple policy definitions |
| Least Privilege | Assign minimum required permissions; scope as narrowly as possible |
| Deallocate vs Stop | Stop from OS = still billed; Deallocate from Portal = compute billing stops |

---

## Related Resources in This Repo

- `vm-template.json` — ARM template export of the VM configuration
- `nsg-rules.json` — NSG rules export
- `policy-initiative.json` — exported Initiative definition
- `budget-config.md` — budget thresholds and alert configuration notes
